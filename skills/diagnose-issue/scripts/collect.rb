#!/usr/bin/env ruby
# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength, Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

require 'json'
require 'net/http'
require 'open3'
require 'optparse'
require 'time'
require 'uri'
require 'yaml'

# Performs read-only CI and deployment diagnosis for one repository target.
class IssueDiagnosisCollector
  HTTP_TIMEOUT_SECONDS = 15
  FINDING_CONFIDENCE = 'High (>=80%)'

  def initialize(options)
    @mode = options.fetch(:mode)
    @repo_path = File.expand_path(options.fetch(:repo_path))
    @target = options.fetch(:target)
    @branch = options[:branch]
    @pipeline = options[:pipeline] || options[:pipeline_id]
    @version = options[:version]
  end

  def call
    root = git_root
    owner_repo = parse_owner_repo(git('remote', 'get-url', 'origin').strip)

    result = case @mode
             when 'ci'
               diagnose_ci(root, owner_repo)
             when 'deployment'
               diagnose_deployment(root, owner_repo)
             else
               base_result(root, owner_repo).merge(findings: [
                                                     finding('error', 'mode', "Unsupported mode: #{@mode}.",
                                                             'Use --mode ci or --mode deployment.')
                                                   ])
             end

    JSON.pretty_generate(result)
  end

  private

  def diagnose_ci(root, owner_repo)
    branch = @branch || current_branch
    branch = default_branch(owner_repo) if branch.empty?
    circleci = collect_circleci_ci(owner_repo, branch)
    target_branch = circleci.is_a?(Hash) ? circleci.dig(:pipeline, :branch) || branch : branch
    findings = ci_findings(target_branch, circleci)
    current_pull_request = github_current_pull_request(owner_repo, target_branch)

    base_result(root, owner_repo).merge(
      target: { type: @pipeline ? 'pipeline' : @target, branch: target_branch, pipeline: @pipeline },
      sources: source_summary(github: current_pull_request, circleci: circleci),
      findings: findings,
      evidence: { github: { current_pull_request: current_pull_request }, circleci: circleci }
    )
  end

  def diagnose_deployment(root, owner_repo)
    service = File.exist?(File.join(root, '.cd'))
    version = @version || latest_version&.fetch(:tag, nil)
    circleci = service ? collect_circleci_deployment(owner_repo, version) : skipped('not a service repo')
    digitalocean = service ? collect_digitalocean : skipped('not a service repo')
    kubernetes = service ? collect_kubernetes(owner_repo.split('/').last) : skipped('not a service repo')
    uptimerobot = service ? collect_uptimerobot(owner_repo.split('/').last) : skipped('not a service repo')

    findings = deployment_findings(service, version, circleci, kubernetes, uptimerobot)

    base_result(root, owner_repo).merge(
      target: { type: @version ? 'version' : @target, version: version, latest_version: latest_version },
      sources: source_summary(circleci: circleci, digitalocean: digitalocean, kubernetes: kubernetes,
                              uptimerobot: uptimerobot),
      findings: findings,
      evidence: {
        circleci: circleci,
        digitalocean: digitalocean,
        kubernetes: kubernetes,
        uptimerobot: uptimerobot
      }
    )
  end

  def base_result(root, owner_repo)
    {
      repository: owner_repo,
      repo_path: root,
      diagnosis_mode: @mode,
      generated_at: Time.now.utc.iso8601
    }
  end

  def collect_circleci_ci(owner_repo, branch)
    token = circleci_token
    return unavailable('CircleCI token not found') if token.nil? || token.empty?

    pipeline = if @pipeline
                 circleci_pipeline_target(owner_repo, @pipeline, token)
               else
                 latest_circleci_pipeline(owner_repo, branch, token)
               end
    return unavailable("No CircleCI pipeline found for #{branch}.") unless pipeline

    collect_circleci_pipeline(owner_repo, pipeline, token)
  rescue StandardError => e
    unavailable(e.message)
  end

  def collect_circleci_deployment(owner_repo, version)
    token = circleci_token
    return unavailable('CircleCI token not found') if token.nil? || token.empty?
    return unavailable('No version tag was found.') if version.nil? || version.empty?

    branch = default_branch(owner_repo)
    revision = git('rev-list', '-n', '1', version, allow_failure: true).strip
    return unavailable("No local tag found for #{version}.") if revision.empty?

    pipeline = circleci_pipeline_for_revision(owner_repo, branch, revision, token)
    return unavailable("No CircleCI pipeline found for #{version}.") unless pipeline

    collect_circleci_pipeline(owner_repo, pipeline, token).merge(version: version, revision: revision)
  rescue StandardError => e
    unavailable(e.message)
  end

  def collect_circleci_pipeline(owner_repo, pipeline, token)
    workflows = circleci_workflows(pipeline.fetch('id'), token)
    jobs = circleci_jobs(owner_repo, workflows, token)
    {
      status: 'used',
      pipeline: pipeline_summary(pipeline),
      workflows: workflows.map { |workflow| workflow_summary(workflow) },
      jobs: jobs.map { |job| job_summary(job) },
      failed_workflows: workflows.reject { |workflow| workflow['status'] == 'success' }.map do |workflow|
        workflow_summary(workflow)
      end,
      failed_jobs: jobs.select { |job| failed_circleci_job?(job) }.map { |job| job_summary(job) },
      deploy_job: jobs.find { |job| job['name'] == 'deploy' }&.then { |job| job_summary(job) }
    }
  end

  def ci_findings(branch, circleci)
    return [source_finding('CircleCI', circleci)] if unavailable_source?(circleci)

    failed_jobs = circleci.fetch(:failed_jobs, [])
    failed_workflows = circleci.fetch(:failed_workflows, [])

    findings = failed_workflows.map do |workflow|
      finding('failure', 'circleci-workflow',
              "#{workflow[:name]} workflow is #{workflow[:status]} on #{branch}.",
              'Inspect the first failed job in this workflow.')
    end

    failed_jobs.each do |job|
      findings << finding('failure', 'circleci-job',
                          "#{job[:name]} is #{job[:status]}#{job_number(job)}#{job_context(job)}.",
                          "Inspect #{job[:name]} logs#{job_url(job)}.")
    end

    findings << clean_finding('No failed jobs were found in the selected CircleCI pipeline.') if findings.empty?
    findings
  end

  def deployment_findings(service, version, circleci, kubernetes, uptimerobot)
    unless service
      return [finding('warning', 'classification', 'This repository does not have a .cd file.',
                      'Deployment diagnosis only runs for repositories marked as deployed with .cd.')]
    end

    findings = []
    deploy = circleci[:deploy_job] if circleci.is_a?(Hash) && !unavailable_source?(circleci)
    findings << source_finding('CircleCI', circleci) if unavailable_source?(circleci)
    findings.concat(deploy_findings(deploy))
    findings.concat(kubernetes_findings(version, kubernetes))
    findings.concat(uptimerobot_findings(uptimerobot))

    findings << clean_finding("No deployment issue was found for #{version}.") if findings.empty?
    findings
  end

  def deploy_findings(deploy)
    unless deploy
      return [finding('warning', 'deploy-job', 'No deploy job was found in the selected pipeline.',
                      'Confirm this version maps to the master pipeline that should deploy it.')]
    end
    return [] if deploy[:status] == 'success'

    [finding('failure', 'deploy-job', "Deploy job is #{deploy[:status]}#{job_number(deploy)}.",
             "Inspect deploy logs#{job_url(deploy)} before checking runtime state.")]
  end

  def kubernetes_findings(version, kubernetes)
    return [source_finding('Kubernetes', kubernetes)] if unavailable_source?(kubernetes)

    findings = []
    kubernetes.fetch(:deployments, []).each do |deployment|
      findings.concat(kubernetes_deployment_findings(version, deployment))
    end
    kubernetes.fetch(:pods, []).each do |pod|
      unless pod[:ready]
        findings << finding('failure', 'kubernetes-pod', "#{pod[:namespace]}/#{pod[:name]} is not ready.",
                            'Describe the pod and inspect container state and events.')
      end
      next unless pod[:restarts].to_i.positive?

      findings << finding('warning', 'kubernetes-restarts',
                          "#{pod[:namespace]}/#{pod[:name]} has #{pod[:restarts]} restart(s).",
                          'Inspect previous container logs and termination reasons.')
    end
    findings
  end

  def kubernetes_deployment_findings(version, deployment)
    findings = []
    desired = deployment[:desired_replicas].to_i
    ready = deployment[:ready_replicas].to_i
    if desired.positive? && ready < desired
      findings << finding('failure', 'kubernetes-deployment',
                          "#{deployment[:namespace]}/#{deployment[:name]} has #{ready}/#{desired} ready replicas.",
                          'Inspect rollout status, image pulls, probes, and recent events.')
    end
    if version && deployment[:image] && !deployment[:image].end_with?(":#{version}")
      findings << finding('failure', 'runtime-version',
                          "#{deployment[:namespace]}/#{deployment[:name]} runs #{deployment[:image]}, not #{version}.",
                          'Confirm the selected version deployed or inspect the deploy job for rollout failure.')
    end
    findings
  end

  def uptimerobot_findings(uptimerobot)
    return [source_finding('UptimeRobot', uptimerobot)] if unavailable_source?(uptimerobot)

    monitor = uptimerobot[:monitor]
    return [] unless monitor && monitor[:status].to_i != 2

    [finding('failure', 'uptimerobot', "#{monitor[:friendly_name]} status is #{monitor[:status]}.",
             'Correlate monitor state with deploy job and Kubernetes readiness.')]
  end

  def latest_circleci_pipeline(owner_repo, branch, token)
    circleci_get("/project/gh/#{owner_repo}/pipeline?branch=#{url_query(branch)}", token).fetch('items', []).first
  end

  def circleci_pipeline_target(owner_repo, target, token)
    return circleci_pipeline_by_number(owner_repo, target.to_i, token) if target.to_s.match?(/\A\d+\z/)

    circleci_pipeline(target, token)
  end

  def circleci_pipeline_by_number(owner_repo, number, token)
    page_token = nil
    50.times do
      path = "/project/gh/#{owner_repo}/pipeline"
      path += "?page-token=#{url_query(page_token)}" if page_token
      data = circleci_get(path, token)
      found = data.fetch('items', []).find { |pipeline| pipeline['number'].to_i == number }
      return found if found

      page_token = data['next_page_token']
      break unless page_token
    end
    nil
  end

  def circleci_pipeline_for_revision(owner_repo, branch, revision, token)
    page_token = nil
    10.times do
      path = "/project/gh/#{owner_repo}/pipeline?branch=#{url_query(branch)}"
      path += "&page-token=#{url_query(page_token)}" if page_token
      data = circleci_get(path, token)
      found = data.fetch('items', []).find { |pipeline| pipeline.dig('vcs', 'revision') == revision }
      return found if found

      page_token = data['next_page_token']
      break unless page_token
    end
    nil
  end

  def circleci_pipeline(id, token)
    circleci_get("/pipeline/#{id}", token)
  end

  def circleci_workflows(pipeline_id, token)
    circleci_get("/pipeline/#{pipeline_id}/workflow", token).fetch('items', [])
  end

  def circleci_jobs(owner_repo, workflows, token)
    workflows.flat_map do |workflow|
      circleci_get("/workflow/#{workflow.fetch('id')}/job", token).fetch('items', []).map do |job|
        enrich_circleci_job(owner_repo, job.merge('workflow_id' => workflow.fetch('id'),
                                                  'workflow_name' => workflow.fetch('name')), token)
      end
    end
  end

  def enrich_circleci_job(owner_repo, job, token)
    enriched = enrich_circleci_job_url(owner_repo, job)
    return enriched unless job['job_number']
    return enriched unless failed_circleci_job?(job) || (job['name'] == 'deploy' && job['status'] != 'not_run')

    details = circleci_get("/project/gh/#{owner_repo}/job/#{job.fetch('job_number')}", token)
    enriched.merge(
      'web_url' => details['web_url'],
      'contexts' => details.fetch('contexts', []).map { |context| context['name'] },
      'messages' => details['messages'],
      'executor' => details['executor']
    )
  rescue StandardError => e
    enriched.merge('details_error' => e.message)
  end

  def enrich_circleci_job_url(owner_repo, job)
    return job unless job['job_number']

    job.merge('web_url' => "https://circleci.com/gh/#{owner_repo}/#{job.fetch('job_number')}")
  end

  def collect_digitalocean
    token = ENV.fetch('DIGITALOCEAN_ACCESS_TOKEN', nil)
    return unavailable('DIGITALOCEAN_ACCESS_TOKEN is not set') if token.nil? || token.empty?

    data = http_json('https://api.digitalocean.com/v2/kubernetes/clusters', 'Authorization' => "Bearer #{token}")
    { status: 'used', clusters: data.fetch('kubernetes_clusters', []).map do |cluster|
      pick(cluster, 'name', 'region', 'version', 'status', 'created_at')
    end }
  rescue StandardError => e
    unavailable(e.message)
  end

  def collect_kubernetes(name)
    return unavailable('kubectl is not installed') unless command_available?('kubectl')

    context = capture('kubectl', 'config', 'current-context', allow_failure: true).strip
    deployments = kubectl_json('get', 'deployments', '-A', '-o', 'json').fetch('items', []).select do |item|
      item.dig('metadata', 'name')&.include?(name) || item.dig('metadata', 'namespace')&.include?(name)
    end
    pods = deployments.flat_map { |deployment| deployment_pods(deployment) }

    {
      status: 'used',
      context: context,
      deployments: deployments.map { |deployment| deployment_summary(deployment) },
      pods: pods.map { |pod| pod_summary(pod) }
    }
  rescue StandardError => e
    unavailable(e.message)
  end

  def deployment_pods(deployment)
    namespace = deployment.dig('metadata', 'namespace')
    labels = deployment.dig('spec', 'selector', 'matchLabels') || {}
    selector = labels.map { |key, value| "#{key}=#{value}" }.join(',')
    return [] if selector.empty?

    kubectl_json('get', 'pods', '-n', namespace, '-l', selector, '-o', 'json').fetch('items', [])
  end

  def collect_uptimerobot(name)
    key = ENV.fetch('UPTIMEROBOT_API_KEY', '').strip
    return unavailable('UPTIMEROBOT_API_KEY is not set') if key.empty?

    params = { 'api_key' => key, 'format' => 'json', 'logs' => '1', 'response_times' => '1' }
    monitor_ids = ENV.fetch('UPTIMEROBOT_MONITOR_IDS', '').split(',').map(&:strip).reject(&:empty?)
    params['monitors'] = monitor_ids.join('-') unless monitor_ids.empty?
    monitor = find_uptimerobot_monitor(uptimerobot(params), name)
    return unavailable("no UptimeRobot monitor matched #{name}") unless monitor

    { status: 'used', monitor: symbolize(pick(monitor, 'id', 'friendly_name', 'url', 'status')),
      logs: monitor.fetch('logs', []) }
  rescue StandardError => e
    unavailable(e.message)
  end

  def deployment_summary(deployment)
    status = deployment.fetch('status', {})
    spec = deployment.fetch('spec', {})
    container = deployment.dig('spec', 'template', 'spec', 'containers', 0) || {}
    {
      namespace: deployment.dig('metadata', 'namespace'),
      name: deployment.dig('metadata', 'name'),
      desired_replicas: spec['replicas'],
      ready_replicas: status['readyReplicas'] || 0,
      available_replicas: status['availableReplicas'] || 0,
      updated_replicas: status['updatedReplicas'] || 0,
      image: container['image']
    }
  end

  def pod_summary(pod)
    statuses = pod.dig('status', 'containerStatuses') || []
    {
      namespace: pod.dig('metadata', 'namespace'),
      name: pod.dig('metadata', 'name'),
      phase: pod.dig('status', 'phase'),
      ready: statuses.any? && statuses.all? { |status| status['ready'] },
      restarts: statuses.sum { |status| status['restartCount'].to_i },
      started_at: pod.dig('status', 'startTime')
    }
  end

  def pipeline_summary(pipeline)
    vcs = pipeline.fetch('vcs', {})
    {
      id: pipeline['id'],
      number: pipeline['number'],
      created_at: pipeline['created_at'],
      branch: vcs['branch'],
      revision: vcs['revision'],
      commit_subject: vcs.dig('commit', 'subject')
    }
  end

  def workflow_summary(workflow)
    symbolize(pick(workflow, 'id', 'name', 'status', 'created_at', 'stopped_at'))
  end

  def job_summary(job)
    symbolize(pick(job, 'job_number', 'name', 'status', 'started_at', 'stopped_at', 'workflow_id',
                   'workflow_name', 'web_url', 'contexts', 'messages', 'details_error'))
  end

  def github_current_pull_request(owner_repo, branch)
    return skipped('gh is not installed') unless command_available?('gh')
    return nil if branch.nil? || branch.empty?

    gh_json(
      'pr', 'list', '--repo', owner_repo, '--head', branch, '--state', 'open',
      '--json', 'number,title,url,headRefName,baseRefName,isDraft,mergeStateStatus,reviewDecision'
    ).first
  rescue StandardError => e
    unavailable(e.message)
  end

  def latest_version
    git_lines('for-each-ref', 'refs/tags', '--sort=-creatordate', '--count=1',
              '--format=%(refname:short)%09%(creatordate:iso-strict)')
      .filter_map do |line|
        tag, created_at = line.split("\t", 2)
        { tag: tag, created_at: created_at } if tag && created_at
      end
      .first
  end

  def source_summary(sources)
    sources.to_h do |name, value|
      status = value.is_a?(Hash) && value[:status] ? value[:status] : 'used'
      reason = value.is_a?(Hash) ? value[:reason] : nil
      [name, reason ? { status: status, reason: reason } : { status: status }]
    end
  end

  def source_finding(source, value)
    finding('unavailable', source.downcase, "#{source} evidence is #{value[:status]}: #{value[:reason]}.",
            "Provide #{source} access or inspect local repository evidence.")
  end

  def clean_finding(message)
    finding('ok', 'evidence', message, 'No fix is indicated from the selected target evidence.')
  end

  def finding(severity, area, evidence, suggestion)
    {
      severity: severity,
      confidence: FINDING_CONFIDENCE,
      area: area,
      evidence: evidence,
      suggestion: suggestion
    }
  end

  def job_number(job)
    job[:job_number] ? " job ##{job[:job_number]}" : ''
  end

  def job_context(job)
    job.fetch(:contexts, []).any? ? "; context #{job.fetch(:contexts).join(', ')}" : ''
  end

  def job_url(job)
    job[:web_url] ? " at #{job[:web_url]}" : ''
  end

  def unavailable_source?(value)
    value.is_a?(Hash) && %w[skipped unavailable].include?(value[:status])
  end

  def failed_circleci_job?(job)
    job['stopped_at'] && !%w[success running on_hold not_run].include?(job['status'])
  end

  def circleci_get(path, token)
    http_json("https://circleci.com/api/v2#{path}", 'Circle-Token' => token)
  end

  def circleci_token
    token = ENV['CIRCLE_TOKEN'] || ENV['CIRCLECI_TOKEN'] || ENV.fetch('CIRCLECI_CLI_TOKEN', nil)
    return token unless token.nil? || token.empty?

    path = ENV['CIRCLECI_CLI_CONFIG'] || File.join(Dir.home, '.circleci', 'cli.yml')
    return nil unless File.exist?(path)

    YAML.safe_load_file(path).fetch('token')
  end

  def uptimerobot(params)
    uri = URI('https://api.uptimerobot.com/v2/getMonitors')
    request = Net::HTTP::Post.new(uri)
    request.set_form_data(params)
    response = http_response(uri, request)
    raise "UptimeRobot #{response.code}: #{response.body}" unless response.is_a?(Net::HTTPSuccess)

    data = JSON.parse(response.body)
    error = data['error']
    raise "UptimeRobot #{error['type']}: #{error['message']}" if data['stat'] == 'fail' && error

    data
  end

  def find_uptimerobot_monitor(data, name)
    data.fetch('monitors', []).find do |item|
      [item['friendly_name'], item['url']].compact.any? { |value| value.include?(name) }
    end
  end

  def http_json(url, headers = {})
    uri = URI(url)
    request = Net::HTTP::Get.new(uri)
    headers.each { |key, value| request[key] = value }
    response = http_response(uri, request)
    raise "#{url} #{response.code}: #{response.body}" unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)
  end

  def http_response(uri, request)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = HTTP_TIMEOUT_SECONDS
    http.read_timeout = HTTP_TIMEOUT_SECONDS
    http.request(request)
  end

  def kubectl_json(*)
    JSON.parse(capture('kubectl', *))
  end

  def gh_json(*)
    JSON.parse(capture('gh', *))
  end

  def git_root
    git('rev-parse', '--show-toplevel').strip
  end

  def git(*, allow_failure: false)
    capture('git', '-C', @repo_path, *, allow_failure: allow_failure)
  end

  def git_lines(*)
    git(*).lines.map(&:chomp).reject(&:empty?)
  end

  def current_branch
    git('branch', '--show-current').strip
  end

  def default_branch(owner_repo)
    branch = git('symbolic-ref', '--quiet', '--short', 'refs/remotes/origin/HEAD', allow_failure: true)
             .strip
             .sub(%r{\Aorigin/}, '')
    return branch unless branch.empty?

    github_default_branch(owner_repo) || current_branch
  end

  def github_default_branch(owner_repo)
    return nil unless command_available?('gh')

    gh_json('repo', 'view', owner_repo, '--json', 'defaultBranchRef').dig('defaultBranchRef', 'name')
  rescue StandardError
    nil
  end

  def capture(*args, allow_failure: false)
    output, error, status = Open3.capture3(*args)
    raise "#{args.join(' ')} failed: #{error.strip}" if !allow_failure && !status.success?

    output
  end

  def command_available?(name)
    ENV.fetch('PATH', '').split(File::PATH_SEPARATOR).any? do |directory|
      path = File.join(directory, name)
      File.executable?(path) && !File.directory?(path)
    end
  end

  def pick(hash, *keys)
    keys.each_with_object({}) { |key, result| result[key] = hash[key] if hash.key?(key) }
  end

  def symbolize(hash)
    hash.to_h { |key, value| [key.to_sym, value] }
  end

  def parse_owner_repo(remote)
    clean = remote.delete_suffix('.git')
    return Regexp.last_match(1) if clean.match(/\Agit@github\.com:(.+)\z/)
    return Regexp.last_match(1) if clean.match(%r{\Assh://git@github\.com/(.+)\z})
    return Regexp.last_match(1) if clean.match(%r{\Ahttps?://github\.com/(.+)\z})

    clean
  end

  def url_query(value)
    URI.encode_www_form_component(value)
  end
end

options = {
  mode: 'ci',
  repo_path: Dir.pwd,
  target: 'latest'
}

OptionParser.new do |parser|
  parser.banner = 'Usage: collect.rb [options]'
  parser.on('--mode MODE', 'Diagnosis mode: ci or deployment. Defaults to ci.') { |value| options[:mode] = value }
  parser.on('--target TARGET', 'Target to inspect. Defaults to latest.') { |value| options[:target] = value }
  parser.on('--pipeline PIPELINE', 'CircleCI pipeline number or UUID for CI diagnosis.') do |value|
    options[:pipeline] = value
  end
  parser.on('--pipeline-id ID', 'CircleCI pipeline UUID for CI diagnosis.') { |value| options[:pipeline_id] = value }
  parser.on('--version VERSION', 'Version tag for deployment diagnosis.') { |value| options[:version] = value }
  parser.on('--branch BRANCH', 'Branch for latest CI pipeline lookup. Defaults to the current branch.') do |value|
    options[:branch] = value
  end
  parser.on('--repo PATH', 'Repository path. Defaults to the current directory.') do |value|
    options[:repo_path] = value
  end
end.parse!

puts IssueDiagnosisCollector.new(options).call

# rubocop:enable Metrics/ClassLength, Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
