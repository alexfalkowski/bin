#!/usr/bin/env ruby
# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength, Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

lib = File.expand_path('../../../lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'skills'

# Performs read-only CI and deployment diagnosis for one repository target.
class IssueDiagnosisCollector
  include EvidenceSources

  FAILED_WORKFLOW_STATUSES = %w[failed error unauthorized].freeze
  ACTIVE_WORKFLOW_STATUSES = %w[running failing on_hold queued].freeze
  CIRCLECI_TEST_RESULT_PAGE_LIMIT = 2
  CIRCLECI_TEST_RESULT_LIMIT = 100
  CIRCLECI_TEST_CLASS_LIMIT = 10
  GITHUB_COMMIT_STATUS_LIMIT = 20

  def initialize(options)
    @mode = options.fetch(:mode)
    @repo_path = File.expand_path(options.fetch(:repo_path))
    @target = options.fetch(:target)
    @branch = options[:branch]
    @pipeline = options[:pipeline] || options[:pipeline_id]
    @revision = options[:revision]
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
               diagnosis_metadata(root, owner_repo).merge(
                 findings: [
                   finding('error', 'mode', "Unsupported mode: #{@mode}.",
                           'Use --mode ci or --mode deployment.')
                 ]
               )
             end

    JSON.pretty_generate(result)
  end

  private

  def diagnose_ci(root, owner_repo)
    branch = @branch || current_branch
    branch = default_branch(owner_repo) if branch.empty?
    revision = resolved_revision
    circleci = collect_circleci_ci(owner_repo, branch, revision)
    target_branch = circleci.is_a?(Hash) ? circleci.dig(:pipeline, :branch) || branch : branch
    findings = ci_findings(target_branch, circleci)
    current_pull_request = github_current_pull_request(owner_repo, target_branch) unless @revision
    pull_requests_for_revision = github_pull_requests_for_revision(owner_repo, revision) if @revision

    target_type = @target
    target_type = 'pipeline' if @pipeline
    target_type = 'revision' if @revision
    target = { type: target_type, branch: target_branch, pipeline: @pipeline }
    target[:revision] = @revision if @revision
    target[:resolved_revision] = revision if @revision && revision != @revision
    github = { current_pull_request: current_pull_request }
    github[:pull_requests_for_revision] = pull_requests_for_revision if @revision
    sources = source_summary(
      github: github_source(current_pull_request, pull_requests_for_revision),
      circleci: circleci
    )

    diagnosis_metadata(root, owner_repo).merge(
      target: target,
      sources: sources,
      findings: findings,
      evidence: { github: github, circleci: circleci }
    )
  end

  def diagnose_deployment(root, owner_repo)
    service = File.exist?(File.join(root, '.cd'))
    version = @version || latest_version&.fetch(:tag, nil)
    evidence = collect_sources([
                                 [:circleci, lambda do
                                   if service
                                     collect_circleci_deployment(owner_repo, version)
                                   else
                                     skipped('not a service repo')
                                   end
                                 end],
                                 [:digitalocean, lambda do
                                   service ? collect_digitalocean : skipped('not a service repo')
                                 end],
                                 [:kubernetes, lambda do
                                   if service
                                     collect_kubernetes(owner_repo.split('/').last)
                                   else
                                     skipped('not a service repo')
                                   end
                                 end],
                                 [:uptimerobot, lambda do
                                   if service
                                     collect_uptimerobot(owner_repo.split('/').last)
                                   else
                                     skipped('not a service repo')
                                   end
                                 end]
                               ])
    circleci = evidence.fetch(:circleci)
    kubernetes = evidence.fetch(:kubernetes)
    uptimerobot = evidence.fetch(:uptimerobot)

    findings = deployment_findings(service, version, circleci, kubernetes, uptimerobot)

    diagnosis_metadata(root, owner_repo).merge(
      target: { type: @version ? 'version' : @target, version: version, latest_version: latest_version },
      sources: source_summary(evidence),
      findings: findings,
      evidence: evidence
    )
  end

  def diagnosis_metadata(root, owner_repo)
    {
      repository: owner_repo,
      repo_path: root,
      diagnosis_mode: @mode,
      generated_at: Time.now.utc.iso8601
    }
  end

  def collect_circleci_ci(owner_repo, branch, revision)
    token = circleci_token
    return unavailable('CircleCI token not found') if token.nil? || token.empty?

    pipeline = if @revision
                 circleci_pipeline_by_revision(owner_repo, revision, token)
               elsif @pipeline
                 circleci_pipeline_target(owner_repo, @pipeline, token)
               else
                 latest_circleci_pipeline(owner_repo, branch, token)
               end
    fallback = circleci_commit_status_fallback(owner_repo, revision) if @revision && pipeline.nil?
    return fallback if fallback
    return unavailable(circleci_pipeline_not_found_reason(branch)) unless pipeline

    collect_circleci_pipeline(owner_repo, pipeline, token)
  rescue StandardError => e
    unavailable_for_error(e)
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
    unavailable_for_error(e)
  end

  def collect_circleci_pipeline(owner_repo, pipeline, token)
    workflows = circleci_workflows(pipeline.fetch('id'), token)
    jobs = circleci_jobs(owner_repo, workflows, token)
    {
      status: 'used',
      pipeline: pipeline_summary(pipeline),
      workflows: workflows.map { |workflow| workflow_summary(workflow) },
      workflow_attempts: workflow_attempt_groups(workflows),
      jobs: jobs.map { |job| job_summary(job) },
      failed_workflows: workflows.select { |workflow| failed_circleci_workflow?(workflow) }.map do |workflow|
        workflow_summary(workflow)
      end,
      active_workflows: workflows.select { |workflow| active_circleci_workflow?(workflow) }.map do |workflow|
        workflow_summary(workflow)
      end,
      failed_jobs: jobs.select { |job| failed_circleci_job?(job) }.map { |job| job_summary(job) },
      deploy_job: jobs.find { |job| job['name'] == 'deploy' }&.then { |job| job_summary(job) }
    }
  end

  def ci_findings(branch, circleci)
    return [source_finding('CircleCI', circleci)] if unavailable_source?(circleci)
    return commit_status_findings(circleci) if circleci[:commit_status_fallback]

    failed_jobs = circleci.fetch(:failed_jobs, [])
    workflow_attempts = circleci.fetch(:workflow_attempts, [])

    findings = []
    workflow_attempts.each do |workflow_group|
      workflow = workflow_group.fetch(:final_attempt)
      attempts = workflow_group.fetch(:attempts)
      attempt_context = workflow_attempt_context(attempts)

      if failed_circleci_workflow?(workflow)
        findings << finding('failure', 'circleci-workflow',
                            "#{workflow[:name]} workflow is #{workflow[:status]} on #{branch}#{attempt_context}.",
                            'Inspect the first failed job in this workflow.')
        failed_jobs.select { |job| job[:workflow_id] == workflow[:id] }.each do |job|
          findings << circleci_job_finding(job)
        end
      elsif active_circleci_workflow?(workflow)
        findings << finding('warning', 'circleci-workflow',
                            "#{workflow[:name]} workflow is #{workflow[:status]} on #{branch}#{attempt_context}.",
                            'Wait for the active workflow to reach a terminal state before diagnosing a failure.')
      elsif attempts.any? { |attempt| failed_circleci_workflow?(attempt) }
        findings << finding('warning', 'circleci-workflow',
                            "#{workflow[:name]} workflow succeeded on #{branch}#{attempt_context}.",
                            'Confirm the earlier failed attempt was transient before relying on the rerun.')
      else
        failed_jobs.select { |job| job[:workflow_id] == workflow[:id] }.each do |job|
          findings << circleci_job_finding(job)
        end
      end
    end

    findings << clean_finding('No failed jobs were found in the selected CircleCI pipeline.') if findings.empty?
    findings
  end

  def commit_status_findings(circleci)
    jobs = circleci.dig(:commit_status_fallback, :jobs) || []
    findings = jobs.filter_map do |job|
      evidence = "CircleCI commit-status job ##{job[:job_number]} is #{job[:status]} for the selected revision."
      case job[:status]
      when 'failed', 'error'
        finding('failure', 'circleci-job', evidence,
                "Inspect the CircleCI job at #{job[:web_url]}.")
      when 'running'
        finding('warning', 'circleci-job', evidence,
                'Wait for the CircleCI job to reach a terminal state before diagnosing a failure.')
      end
    end
    if findings.empty?
      findings << clean_finding('No failed CircleCI commit-status jobs were found for the selected revision.')
    end
    findings
  end

  def circleci_job_finding(job)
    evidence = "#{job[:name]} is #{job[:status]}#{job_number(job)}#{job_context(job)}#{job_failed_step(job)}."
    finding('failure', 'circleci-job', evidence, "Inspect #{job[:name]} logs#{job_url(job)}.")
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

  def circleci_pipeline_by_revision(owner_repo, revision, token)
    page_token = nil
    50.times do
      path = "/project/gh/#{owner_repo}/pipeline"
      path += "?page-token=#{url_query(page_token)}" if page_token
      data = circleci_get(path, token)
      found = data.fetch('items', []).find { |pipeline| pipeline.dig('vcs', 'revision') == revision }
      return found if found

      page_token = data['next_page_token']
      break unless page_token
    end
    nil
  end

  def circleci_commit_status_fallback(owner_repo, revision)
    return nil unless command_available?('gh')

    statuses = gh_json(
      'api', "repos/#{owner_repo}/commits/#{url_query(revision)}/status?per_page=#{GITHUB_COMMIT_STATUS_LIMIT}"
    ).fetch('statuses', [])
    jobs = statuses.first(GITHUB_COMMIT_STATUS_LIMIT).filter_map do |status|
      circleci_commit_status_job(status, owner_repo)
    end
    jobs = jobs.uniq { |job| job[:job_number] }
    return nil if jobs.empty?

    {
      status: 'used',
      pipeline: nil,
      workflows: [],
      workflow_attempts: [],
      jobs: [],
      failed_workflows: [],
      active_workflows: [],
      failed_jobs: [],
      deploy_job: nil,
      pipeline_lookup: unavailable(circleci_pipeline_not_found_reason('')),
      commit_status_fallback: { status: 'used', revision: revision, jobs: jobs }
    }
  rescue StandardError
    nil
  end

  def circleci_commit_status_job(status, owner_repo)
    job_number = circleci_job_number_from_status_url(status['target_url'], owner_repo)
    return nil unless job_number

    job_status = circleci_commit_status(status['state'])
    return nil unless job_status

    {
      job_number: job_number,
      status: job_status,
      web_url: "https://circleci.com/gh/#{owner_repo}/#{job_number}"
    }
  end

  def circleci_job_number_from_status_url(target_url, owner_repo)
    match = target_url.to_s.match(%r{\Ahttps://circleci\.com/gh/#{Regexp.escape(owner_repo)}/(\d+)(?:\z|[?#])})
    match && match[1]
  end

  def circleci_commit_status(status)
    { 'failure' => 'failed', 'error' => 'error', 'pending' => 'running', 'success' => 'success' }[status]
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

  def circleci_v1_get(path, token)
    http_json("https://circleci.com/api/v1.1#{path}", 'Circle-Token' => token)
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
    if job['job_number'].nil?
      return enriched unless failed_circleci_job?(job)

      return enriched.merge('failed_step_metadata_limitation' => 'CircleCI did not provide a job number.')
    end
    return enriched unless failed_circleci_job?(job) || (job['name'] == 'deploy' && job['status'] != 'not_run')

    details = circleci_get("/project/gh/#{owner_repo}/job/#{job.fetch('job_number')}", token)
    enriched = enriched.merge(
      'web_url' => details['web_url'],
      'contexts' => details.fetch('contexts', []).map { |context| context['name'] },
      'messages' => details['messages'],
      'executor' => details['executor']
    )
    return enriched unless failed_circleci_job?(job)

    enriched.merge(failed_step_metadata_with_fallback(owner_repo, job, details, token))
            .merge(circleci_test_result_summary(owner_repo, job, token))
  rescue StandardError => e
    result = enriched.merge('details_error' => source_error_reason(e))
    return result unless failed_circleci_job?(job)

    result.merge(failed_step_metadata_fallback(owner_repo, job, token, 'CircleCI job details are unavailable.'))
          .merge(circleci_test_result_summary(owner_repo, job, token))
  end

  def failed_step_metadata_with_fallback(owner_repo, job, details, token)
    metadata = failed_step_metadata(details, 'circleci-v2')
    return metadata if metadata['failed_step']

    failed_step_metadata_fallback(owner_repo, job, token, metadata['failed_step_metadata_limitation'])
  end

  def failed_step_metadata_fallback(owner_repo, job, token, limitation)
    path = "/project/github/#{owner_repo}/#{job.fetch('job_number')}"
    metadata = failed_step_metadata(circleci_v1_get(path, token), 'circleci-v1')
    return metadata if metadata['failed_step']

    failed_step_metadata_unavailable(metadata['failed_step_metadata_limitation'])
  rescue StandardError
    failed_step_metadata_unavailable(limitation)
  end

  def failed_step_metadata_unavailable(limitation)
    {
      'failed_step_metadata_limitation' => limitation,
      'failed_step_fallback' => { 'source' => 'circleci-v1', 'status' => 'unavailable', 'reason' => limitation }
    }
  end

  def failed_step_metadata(details, source)
    details.fetch('steps', []).each do |step|
      action = step.fetch('actions', []).find { |candidate| failed_circleci_step?(candidate) }
      next unless action

      failed_step = pick(step, 'name').merge(pick(action, 'status', 'exit_code')).merge('source' => source)
      return { 'failed_step' => failed_step }
    end
    { 'failed_step_metadata_limitation' => 'CircleCI did not report a failed step.' }
  end

  def circleci_test_result_summary(owner_repo, job, token)
    results = []
    page_token = nil
    pages = 0
    truncated = false

    loop do
      path = "/project/gh/#{owner_repo}/#{job.fetch('job_number')}/tests"
      path += "?page-token=#{url_query(page_token)}" if page_token
      data = circleci_get(path, token)
      items = data.fetch('items', [])
      remaining = CIRCLECI_TEST_RESULT_LIMIT - results.length
      results.concat(items.first(remaining))
      pages += 1
      page_token = data['next_page_token']
      truncated = items.length > remaining || (page_token && (pages >= CIRCLECI_TEST_RESULT_PAGE_LIMIT ||
        results.length >= CIRCLECI_TEST_RESULT_LIMIT))
      break if page_token.nil? || truncated
    end

    { 'test_results' => summarized_test_results(results, truncated) }
  rescue StandardError => e
    { 'test_results' => { 'status' => 'unavailable', 'reason' => source_error_reason(e) } }
  end

  def summarized_test_results(results, truncated)
    failures = results.reject { |result| %w[success skipped].include?(test_result_value(result, 'result')) }
    grouped = failures.group_by { |result| test_result_value(result, 'result') }.sort.to_h do |result, grouped_results|
      [result, summarized_test_classes(grouped_results)]
    end
    grouped_failures = failures.group_by { |result| test_result_value(result, 'result') }
    class_limit_reached = grouped_failures.any? do |_result, grouped_results|
      grouped_results.map { |result| test_result_value(result, 'classname') }.uniq.length > CIRCLECI_TEST_CLASS_LIMIT
    end
    {
      'status' => 'used',
      'total' => failures.length,
      'failures' => grouped.map { |result, test_classes| { 'result' => result, 'test_classes' => test_classes } },
      'truncated' => truncated || class_limit_reached
    }
  end

  def summarized_test_classes(results)
    results.group_by { |result| test_result_value(result, 'classname') }
           .sort_by { |classname, grouped_results| [-grouped_results.length, classname] }
           .first(CIRCLECI_TEST_CLASS_LIMIT)
           .map { |classname, grouped_results| { 'classname' => classname, 'count' => grouped_results.length } }
  end

  def test_result_value(result, key)
    value = result[key]
    value.nil? || value.empty? ? 'unknown' : value
  end

  def failed_circleci_step?(step)
    status = step['status']
    status && !%w[success running on_hold not_run].include?(status)
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
    unavailable_for_error(e)
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
    unavailable_for_error(e)
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
    data = uptimerobot(params)
    monitor = find_uptimerobot_monitor(data, name)

    if monitor.nil? && !monitor_ids.empty?
      params.delete('monitors')
      data = uptimerobot(params)
      monitor = find_uptimerobot_monitor(data, name)
    end
    return unavailable("no UptimeRobot monitor matched #{name}") unless monitor

    { status: 'used', monitor: symbolize(pick(monitor, 'id', 'friendly_name', 'url', 'status')),
      logs: monitor.fetch('logs', []) }
  rescue StandardError => e
    unavailable_for_error(e)
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
    conditions = pod.dig('status', 'conditions') || []
    ready_condition = conditions.find { |condition| condition['type'] == 'Ready' }
    {
      namespace: pod.dig('metadata', 'namespace'),
      name: pod.dig('metadata', 'name'),
      phase: pod.dig('status', 'phase'),
      ready: ready_condition ? ready_condition['status'] == 'True' : false,
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
    keys = %w[id name status created_at stopped_at auto_rerun_number max_auto_reruns]
    symbolize(pick(workflow, *keys))
  end

  def job_summary(job)
    symbolize(pick(job, 'job_number', 'name', 'status', 'started_at', 'stopped_at', 'workflow_id',
                   'workflow_name', 'web_url', 'contexts', 'messages', 'details_error', 'failed_step',
                   'failed_step_metadata_limitation', 'failed_step_fallback', 'test_results'))
  end

  def github_current_pull_request(owner_repo, branch)
    return skipped('gh is not installed') unless command_available?('gh')
    return nil if branch.nil? || branch.empty?

    gh_json(
      'pr', 'list', '--repo', owner_repo, '--head', branch, '--state', 'open',
      '--json', 'number,title,url,headRefName,baseRefName,isDraft,mergeStateStatus,reviewDecision'
    ).first
  rescue StandardError => e
    unavailable_for_error(e)
  end

  def github_pull_requests_for_revision(owner_repo, revision)
    return skipped('gh is not installed') unless command_available?('gh')

    gh_json(
      'pr', 'list', '--repo', owner_repo, '--search', revision, '--state', 'all', '--limit', '100',
      '--json', 'number,title,url,state,headRefName,baseRefName,isDraft,mergedAt,closedAt'
    )
  rescue StandardError => e
    unavailable_for_error(e)
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

  def job_failed_step(job)
    step = job[:failed_step]
    return '' unless step

    exit_code = step['exit_code']
    suffix = exit_code.nil? ? '' : " with exit code #{exit_code}"
    "; failed step #{step['name']} is #{step['status']}#{suffix}"
  end

  def unavailable_source?(value)
    value.is_a?(Hash) && %w[skipped unavailable].include?(value[:status])
  end

  def failed_circleci_job?(job)
    job['stopped_at'] && !%w[success running on_hold not_run].include?(job['status'])
  end

  def failed_circleci_workflow?(workflow)
    FAILED_WORKFLOW_STATUSES.include?(workflow['status'] || workflow[:status])
  end

  def active_circleci_workflow?(workflow)
    ACTIVE_WORKFLOW_STATUSES.include?(workflow['status'] || workflow[:status])
  end

  def circleci_pipeline_not_found_reason(branch)
    return "No CircleCI pipeline found for revision #{@revision}." if @revision

    "No CircleCI pipeline found for #{branch}."
  end

  def circleci_token
    token = ENV['CIRCLE_TOKEN'] || ENV['CIRCLECI_TOKEN'] || ENV.fetch('CIRCLECI_CLI_TOKEN', nil)
    return token unless token.nil? || token.empty?

    path = ENV['CIRCLECI_CLI_CONFIG'] || File.join(Dir.home, '.circleci', 'cli.yml')
    return nil unless File.exist?(path)

    YAML.safe_load_file(path).fetch('token')
  end

  def find_uptimerobot_monitor(data, name)
    data.fetch('monitors', []).find do |item|
      [item['friendly_name'], item['url']].compact.any? { |value| value.include?(name) }
    end
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

  def symbolize(hash)
    hash.to_h { |key, value| [key.to_sym, value] }
  end

  def resolved_revision
    return @revision unless abbreviated_sha?(@revision)

    resolved = git('rev-parse', '--verify', '--end-of-options', "#{@revision}^{commit}", allow_failure: true).strip
    resolved.empty? ? @revision : resolved
  end

  def abbreviated_sha?(revision)
    revision&.match?(/\A[0-9a-f]{4,40}\z/i)
  end

  def github_source(current_pull_request, pull_requests_for_revision)
    return pull_requests_for_revision if unavailable_source?(pull_requests_for_revision)
    return current_pull_request if unavailable_source?(current_pull_request)

    {}
  end

  def workflow_attempt_groups(workflows)
    workflows.group_by { |workflow| workflow['name'] }.map do |name, attempts|
      attempts = attempts.sort_by do |workflow|
        [workflow.fetch('auto_rerun_number', 0).to_i, workflow.fetch('created_at', ''), workflow.fetch('id')]
      end
      summaries = attempts.map { |workflow| workflow_summary(workflow) }
      { name: name, attempts: summaries, final_attempt: summaries.last }
    end
  end

  def workflow_attempt_context(attempts)
    return '' unless attempts.length > 1 || attempts.last[:auto_rerun_number].to_i.positive?

    " after automatic rerun attempts #{attempts.filter_map { |attempt| attempt[:auto_rerun_number] }.join(', ')}"
  end
end

def validate_selector_options!(options)
  return unless options[:revision]

  conflicts = []
  conflicts << '--pipeline' if options[:pipeline]
  conflicts << '--pipeline-id' if options[:pipeline_id]
  conflicts << '--branch' if options[:branch]
  conflicts << '--version' if options[:version]
  unless conflicts.empty?
    raise OptionParser::InvalidArgument, "--revision cannot be combined with #{conflicts.join(', ')}"
  end
  return if options[:mode] == 'ci'

  raise OptionParser::InvalidArgument, '--revision is only supported with --mode ci'
end

options = {
  mode: 'ci',
  repo_path: Dir.pwd,
  target: 'latest'
}

parser = OptionParser.new do |parser|
  parser.banner = 'Usage: collect.rb [options]'
  parser.on('--mode MODE', 'Diagnosis mode: ci or deployment. Defaults to ci.') { |value| options[:mode] = value }
  parser.on('--target TARGET', 'Target to inspect. Defaults to latest.') { |value| options[:target] = value }
  parser.on('--pipeline PIPELINE', 'CircleCI pipeline number or UUID for CI diagnosis.') do |value|
    options[:pipeline] = value
  end
  parser.on('--pipeline-id ID', 'CircleCI pipeline UUID for CI diagnosis.') { |value| options[:pipeline_id] = value }
  parser.on(
    '--revision SHA',
    'Commit revision for CI diagnosis (unique abbreviations are resolved locally).'
  ) do |value|
    options[:revision] = value
  end
  parser.on('--version VERSION', 'Version tag for deployment diagnosis.') { |value| options[:version] = value }
  parser.on('--branch BRANCH', 'Branch for latest CI pipeline lookup. Defaults to the current branch.') do |value|
    options[:branch] = value
  end
  parser.on('--repo PATH', 'Repository path. Defaults to the current directory.') do |value|
    options[:repo_path] = value
  end
end

begin
  parser.parse!
  validate_selector_options!(options)
rescue OptionParser::ParseError => e
  warn "diagnose-issue: #{e.message}"
  exit 2
end

puts IssueDiagnosisCollector.new(options).call

# rubocop:enable Metrics/ClassLength, Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
