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

# Collects read-only repository productivity evidence from local and remote
# sources, then prints a JSON document for the skill to summarize.
class ProductivityCollector
  HTTP_TIMEOUT_SECONDS = 15

  def initialize(options)
    @repo_path = File.expand_path(options.fetch(:repo_path))
    @timezone = options.fetch(:timezone)
    @branch = options[:branch]
    @include_jobs = options.fetch(:include_jobs)
    @now = options[:now] ? parse_time(options[:now]) : Time.now
    @current_end = options[:current_end] ? parse_time(options[:current_end]) : day_start(@now)
    @current_start = options[:current_start] ? parse_time(options[:current_start]) : @current_end - (7 * 24 * 60 * 60)
    @previous_end = @current_start
    @previous_start = options[:previous_start] ? parse_time(options[:previous_start]) : @previous_end - window_seconds
  end

  def call
    root = git_root
    owner_repo = parse_owner_repo(git('remote', 'get-url', 'origin').strip)
    branch = summary_branch(owner_repo)
    mode = File.exist?(File.join(root, '.cd')) ? 'service' : 'library'
    period = window_seconds <= 24 * 60 * 60 ? 'daily' : 'weekly'

    result = {
      repository: owner_repo,
      repo_path: root,
      branch: branch,
      mode: "#{mode} #{period} summary",
      timezone: @timezone,
      window: window_hash(@current_start, @current_end),
      comparison_window: window_hash(@previous_start, @previous_end),
      local: collect_local(root),
      github: collect_github(owner_repo),
      circleci: collect_circleci(owner_repo, branch, mode, root),
      digitalocean: mode == 'service' ? collect_digitalocean : skipped('not a service repo'),
      kubernetes: mode == 'service' ? collect_kubernetes(owner_repo.split('/').last) : skipped('not a service repo'),
      uptimerobot: mode == 'service' ? collect_uptimerobot(owner_repo.split('/').last) : skipped('not a service repo')
    }

    JSON.pretty_generate(summary_result(result))
  end

  private

  def parse_time(value)
    with_timezone { Time.parse(value) }
  end

  def day_start(time)
    with_timezone do
      local = Time.local(time.year, time.month, time.day)
      Time.parse(local.strftime('%Y-%m-%d 00:00:00 %z'))
    end
  end

  def with_timezone
    old = ENV.fetch('TZ', nil)
    ENV['TZ'] = @timezone
    yield
  ensure
    ENV['TZ'] = old
  end

  def window_seconds
    @current_end.to_i - @current_start.to_i
  end

  def window_hash(start_time, end_time)
    { start: start_time.iso8601, end: end_time.iso8601 }
  end

  def collect_local(root)
    {
      cd_file: File.exist?(File.join(root, '.cd')),
      current: local_period(@current_start, @current_end),
      previous: local_period(@previous_start, @previous_end),
      circleci_config: circleci_config(root)
    }
  end

  def local_period(start_time, end_time)
    commits = git_lines(
      'log', "--since=#{start_time.iso8601}", "--until=#{end_time.iso8601}",
      '--no-merges', '--format=%H%x09%aI%x09%an%x09%s'
    ).map do |line|
      sha, authored_at, author, subject = line.split("\t", 4)
      { sha: sha, authored_at: authored_at, author: author, subject: subject }
    end

    tags = git_lines('for-each-ref', 'refs/tags', '--sort=creatordate',
                     '--format=%(refname:short)%09%(creatordate:iso-strict)')
           .filter_map do |line|
      tag, created_at = line.split("\t", 2)
      next unless created_at

      created = Time.parse(created_at)
      { tag: tag, created_at: created_at } if created >= start_time && created < end_time
    end

    rollback_subjects = commits.filter_map { |commit| commit[:subject] if commit[:subject]&.match?(/revert|rollback/i) }

    {
      commit_count: commits.length,
      commits: commits,
      tag_count: tags.length,
      tags: tags,
      rollback_or_revert_count: rollback_subjects.length,
      rollback_or_revert_subjects: rollback_subjects
    }
  end

  def circleci_config(root)
    path = File.join(root, '.circleci', 'config.yml')
    return { present: false } unless File.exist?(path)

    data = YAML.safe_load_file(path, aliases: true) || {}
    workflow = data.fetch('workflows', {}).find { |key, _| key != 'version' }&.last || {}
    {
      present: true,
      max_auto_reruns: workflow['max_auto_reruns'],
      workflows: data.fetch('workflows', {}).keys.reject { |key| key == 'version' },
      jobs: data.fetch('jobs', {}).keys
    }
  rescue Psych::SyntaxError => e
    { present: true, error: e.message }
  end

  def collect_github(owner_repo)
    return skipped('gh is not installed') unless command_available?('gh')

    open_prs = gh_json(
      'pr', 'list', '--repo', owner_repo, '--state', 'open',
      '--json', 'number,title,createdAt,updatedAt,url'
    )
    stale_prs = open_prs.select do |pull_request|
      updated = pull_request['updatedAt'] && Time.parse(pull_request.fetch('updatedAt'))
      updated && updated < @current_end - (7 * 24 * 60 * 60)
    end

    {
      current: github_period(owner_repo, @current_start, @current_end),
      previous: github_period(owner_repo, @previous_start, @previous_end),
      open_pr_count: open_prs.length,
      open_prs: open_prs,
      stale_pr_count: stale_prs.length,
      stale_prs: stale_prs
    }
  rescue StandardError => e
    unavailable(e.message)
  end

  def github_period(owner_repo, start_time, end_time)
    date_range = "#{start_time.strftime('%Y-%m-%d')}..#{(end_time - 1).strftime('%Y-%m-%d')}"
    merged = gh_json(
      'pr', 'list', '--repo', owner_repo, '--state', 'merged', '--search', "merged:#{date_range}",
      '--limit', '300', '--json', 'number,title,createdAt,mergedAt,url,reviews'
    ).select { |pr| within?(Time.parse(pr.fetch('mergedAt')), start_time, end_time) }

    created = gh_json(
      'pr', 'list', '--repo', owner_repo, '--state', 'all', '--search', "created:#{date_range}",
      '--limit', '300', '--json', 'number,createdAt'
    ).count { |pr| within?(Time.parse(pr.fetch('createdAt')), start_time, end_time) }

    closed_unmerged = gh_json(
      'pr', 'list', '--repo', owner_repo, '--state', 'closed',
      '--search', "closed:#{date_range} -merged:#{date_range}", '--limit', '300', '--json', 'number,closedAt,mergedAt'
    ).count do |pr|
      pr['mergedAt'].nil? && pr['closedAt'] && within?(Time.parse(pr.fetch('closedAt')), start_time,
                                                       end_time)
    end

    review_latencies = merged.filter_map { |pr| first_review_latency(pr) }
    {
      pr_opened: created,
      pr_merged: merged.length,
      pr_closed_unmerged: closed_unmerged,
      median_pr_age_seconds: median(merged.map do |pr|
        Time.parse(pr.fetch('mergedAt')) - Time.parse(pr.fetch('createdAt'))
      end),
      median_review_latency_seconds: median(review_latencies),
      prs_with_reviews: merged.count { |pr| pr.fetch('reviews', []).any? },
      merged_prs: merged.map { |pr| pick(pr, 'number', 'title', 'createdAt', 'mergedAt', 'url') }
    }
  end

  def first_review_latency(pull_request)
    created = Time.parse(pull_request.fetch('createdAt'))
    first = pull_request.fetch('reviews', [])
                        .filter_map { |review| review['submittedAt'] }
                        .map { |value| Time.parse(value) }
                        .min
    first - created if first
  end

  def collect_circleci(owner_repo, branch, mode, root)
    root_config = circleci_config(root)
    return skipped('no .circleci/config.yml') unless root_config[:present]

    token = circleci_token
    return unavailable('CircleCI token not found') if token.nil? || token.empty?

    pipelines = circleci_pipelines(owner_repo, branch, token)
    workflows = circleci_workflows(pipelines, token)
    jobs = @include_jobs || mode == 'service' ? circleci_jobs(workflows, token) : []
    flaky = circleci_get("/insights/gh/#{owner_repo}/flaky-tests?branch=#{url_query(branch)}", token)

    {
      current: circleci_period(workflows, jobs, @current_start, @current_end),
      previous: circleci_period(workflows, jobs, @previous_start, @previous_end),
      flaky_tests: {
        total: flaky['total_flaky_tests'],
        examples: flaky.fetch('flaky_tests', []).map do |test|
          pick(test, 'classname', 'test_name', 'times_flaked', 'workflow_name', 'job_name', 'workflow_created_at')
        end
      },
      config: root_config,
      pipelines_collected: pipelines.length,
      workflows_collected: workflows.length,
      jobs_collected: jobs.length
    }
  rescue StandardError => e
    unavailable(e.message)
  end

  def circleci_period(workflows, jobs, start_time, end_time)
    period_workflows = workflows.select do |workflow|
      within?(Time.parse(workflow.fetch('created_at')), start_time, end_time)
    end
    completed = period_workflows.select do |workflow|
      workflow['stopped_at'] && !%w[running on_hold not_run].include?(workflow['status'])
    end
    successful = completed.count { |workflow| workflow['status'] == 'success' }
    failed = completed.reject { |workflow| workflow['status'] == 'success' }
    durations = completed.map do |workflow|
      Time.parse(workflow.fetch('stopped_at')) - Time.parse(workflow.fetch('created_at'))
    end

    {
      workflows_total: period_workflows.length,
      workflows_completed: completed.length,
      workflows_successful: successful,
      workflows_failed: failed.length,
      workflow_success_rate: completed.empty? ? nil : successful.to_f / completed.length,
      median_workflow_duration_seconds: median(durations),
      p95_workflow_duration_seconds: percentile(durations, 0.95),
      failed_workflows: failed.map { |workflow| pick(workflow, 'name', 'status', 'created_at') },
      jobs: job_summary(jobs, start_time, end_time)
    }
  end

  def job_summary(jobs, start_time, end_time)
    period_jobs = jobs.select do |job|
      value = job['started_at'] || job['created_at'] || job['workflow_created_at']
      value && within?(Time.parse(value), start_time, end_time)
    end

    period_jobs.group_by { |job| job['name'] }.transform_values do |items|
      completed = items.select { |job| job['stopped_at'] && !%w[running on_hold not_run].include?(job['status']) }
      successful = completed.count { |job| job['status'] == 'success' }
      failed = completed.reject { |job| job['status'] == 'success' }
      durations = completed.filter_map do |job|
        started = job['started_at'] || job['created_at'] || job['workflow_created_at']
        Time.parse(job.fetch('stopped_at')) - Time.parse(started) if started
      end

      {
        total: completed.length,
        successful: successful,
        failed: failed.length,
        median_duration_seconds: median(durations),
        p95_duration_seconds: percentile(durations, 0.95),
        failed_jobs: failed.map { |job| pick(job, 'status', 'started_at', 'created_at') }
      }
    end
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

    pods = deployments.flat_map do |deployment|
      namespace = deployment.dig('metadata', 'namespace')
      labels = deployment.dig('spec', 'selector', 'matchLabels') || {}
      selector = labels.map { |key, value| "#{key}=#{value}" }.join(',')
      next [] if selector.empty?

      kubectl_json('get', 'pods', '-n', namespace, '-l', selector, '-o', 'json').fetch('items', [])
    end

    {
      status: 'used',
      context: context,
      deployments: deployments.map { |deployment| deployment_summary(deployment) },
      pods: pods.map { |pod| pod_summary(pod) }
    }
  rescue StandardError => e
    unavailable(e.message)
  end

  def collect_uptimerobot(name)
    key = ENV.fetch('UPTIMEROBOT_API_KEY', '').strip
    return unavailable('UPTIMEROBOT_API_KEY is not set') if key.empty?

    ranges = "#{@current_start.to_i}_#{@current_end.to_i}-#{@previous_start.to_i}_#{@previous_end.to_i}"
    params = {
      'api_key' => key,
      'format' => 'json',
      'logs' => '1',
      'response_times' => '1',
      'custom_uptime_ranges' => ranges
    }
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

    samples = monitor.fetch('response_times', [])
    current_samples = response_samples(samples, @current_start, @current_end)
    previous_samples = response_samples(samples, @previous_start, @previous_end)

    {
      status: 'used',
      monitor: pick(monitor, 'id', 'friendly_name', 'url', 'status'),
      uptime_ranges: monitor['custom_uptime_ranges'] || monitor['custom_uptime_range'],
      logs: monitor.fetch('logs', []),
      current_response_time_average_ms: average(current_samples),
      current_response_time_samples: current_samples.length,
      previous_response_time_average_ms: average(previous_samples),
      previous_response_time_samples: previous_samples.length
    }
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
      ready: statuses.all? { |status| status['ready'] },
      restarts: statuses.sum { |status| status['restartCount'].to_i },
      started_at: pod.dig('status', 'startTime')
    }
  end

  def response_samples(samples, start_time, end_time)
    selected = samples.select do |sample|
      timestamp = sample.fetch('datetime').to_i
      timestamp >= start_time.to_i && timestamp < end_time.to_i
    end
    selected.map { |sample| sample.fetch('value').to_f }
  end

  def find_uptimerobot_monitor(data, name)
    data.fetch('monitors', []).find do |item|
      [item['friendly_name'], item['url']].compact.any? { |value| value.include?(name) }
    end
  end

  def summary_result(result)
    {
      repository: result[:repository],
      repo_path: result[:repo_path],
      branch: result[:branch],
      mode: result[:mode],
      timezone: result[:timezone],
      window: result[:window],
      comparison_window: result[:comparison_window],
      sources: source_summary(result),
      delivery_flow: summary_delivery_flow(result),
      ci_quality: summary_ci_quality(result),
      release_and_deploy: summary_release_and_deploy(result),
      service_reliability: summary_service_reliability(result),
      notable_work: summary_notable_work(result)
    }
  end

  def source_summary(result)
    %i[local github circleci digitalocean kubernetes uptimerobot].to_h do |name|
      value = result[name]
      status = value.is_a?(Hash) && value[:status] ? value[:status] : 'used'
      notes = value.is_a?(Hash) ? value[:reason] : nil
      [name, notes ? { status: status, notes: notes } : { status: status }]
    end
  end

  def summary_delivery_flow(result)
    github = result[:github]
    {
      current: summary_delivery_period(result.dig(:local, :current), summary_github_period(github, :current)),
      previous: summary_delivery_period(result.dig(:local, :previous), summary_github_period(github, :previous)),
      open_pr_count: github_value(github, :open_pr_count),
      stale_pr_count: github_value(github, :stale_pr_count),
      stale_prs: github_value(github, :stale_prs)
    }
  end

  def summary_delivery_period(local, github)
    {
      commit_count: local && local[:commit_count],
      pr_opened: github && github[:pr_opened],
      pr_merged: github && github[:pr_merged],
      pr_closed_unmerged: github && github[:pr_closed_unmerged],
      median_pr_age_seconds: github && github[:median_pr_age_seconds],
      median_review_latency_seconds: github && github[:median_review_latency_seconds],
      prs_with_reviews: github && github[:prs_with_reviews],
      rollback_or_revert_count: local && local[:rollback_or_revert_count]
    }
  end

  def summary_ci_quality(result)
    circleci = result[:circleci]
    return circleci if unavailable_source?(circleci)

    {
      current: summary_ci_period(circleci[:current]),
      previous: summary_ci_period(circleci[:previous]),
      flaky_tests: circleci[:flaky_tests],
      config: circleci[:config],
      pipelines_collected: circleci[:pipelines_collected],
      workflows_collected: circleci[:workflows_collected],
      jobs_collected: circleci[:jobs_collected]
    }
  end

  def summary_ci_period(period)
    return nil unless period

    {
      workflows_total: period[:workflows_total],
      workflows_completed: period[:workflows_completed],
      workflows_successful: period[:workflows_successful],
      workflows_failed: period[:workflows_failed],
      workflow_success_rate: period[:workflow_success_rate],
      median_workflow_duration_seconds: period[:median_workflow_duration_seconds],
      p95_workflow_duration_seconds: period[:p95_workflow_duration_seconds],
      failed_workflows: period[:failed_workflows],
      deploy_job: period.dig(:jobs, 'deploy')
    }
  end

  def summary_release_and_deploy(result)
    {
      current: summary_release_period(result.dig(:local, :current), result.dig(:circleci, :current)),
      previous: summary_release_period(result.dig(:local, :previous), result.dig(:circleci, :previous))
    }
  end

  def summary_release_period(local, circleci)
    deploy_job = circleci&.dig(:jobs, 'deploy')
    {
      tag_count: local && local[:tag_count],
      tags: local && local[:tags],
      rollback_or_revert_count: local && local[:rollback_or_revert_count],
      rollback_or_revert_subjects: local && local[:rollback_or_revert_subjects],
      deploy_job: deploy_job
    }
  end

  def summary_service_reliability(result)
    {
      digitalocean: result[:digitalocean],
      kubernetes: summary_kubernetes(result[:kubernetes]),
      uptimerobot: summary_uptimerobot(result[:uptimerobot])
    }
  end

  def summary_kubernetes(kubernetes)
    return kubernetes if unavailable_source?(kubernetes)

    pods = kubernetes.fetch(:pods, [])
    {
      status: kubernetes[:status],
      context: kubernetes[:context],
      deployments: kubernetes[:deployments],
      pod_count: pods.length,
      ready_pod_count: pods.count { |pod| pod[:ready] },
      pod_restart_count: pods.sum { |pod| pod[:restarts].to_i },
      pods: pods
    }
  end

  def summary_uptimerobot(uptimerobot)
    return uptimerobot if unavailable_source?(uptimerobot)

    current_uptime, previous_uptime = uptime_ranges(uptimerobot)
    {
      status: uptimerobot[:status],
      monitor: uptimerobot[:monitor],
      current_uptime: current_uptime,
      previous_uptime: previous_uptime,
      logs: uptimerobot[:logs],
      current_response_time_average_ms: uptimerobot[:current_response_time_average_ms],
      current_response_time_samples: uptimerobot[:current_response_time_samples],
      previous_response_time_average_ms: uptimerobot[:previous_response_time_average_ms],
      previous_response_time_samples: uptimerobot[:previous_response_time_samples]
    }
  end

  def summary_notable_work(result)
    github = result[:github]
    return github[:current][:merged_prs].first(20) if github.is_a?(Hash) && github.dig(:current, :merged_prs)

    result.dig(:local, :current, :commits)&.map do |commit|
      pick_symbol(commit, :sha, :authored_at, :subject)
    end&.first(20)
  end

  def summary_github_period(github, period)
    github[period] if github.is_a?(Hash) && !github[:status]
  end

  def github_value(github, key)
    github[key] if github.is_a?(Hash) && !github[:status]
  end

  def unavailable_source?(value)
    value.is_a?(Hash) && %w[skipped unavailable].include?(value[:status])
  end

  def uptime_ranges(uptimerobot)
    uptimerobot.fetch(:uptime_ranges, '').split('-', 2)
  end

  def pick_symbol(hash, *keys)
    keys.each_with_object({}) { |key, result| result[key] = hash[key] if hash.key?(key) }
  end

  def circleci_pipelines(owner_repo, branch, token)
    pipelines = []
    page_token = nil
    loop do
      path = "/project/gh/#{owner_repo}/pipeline?branch=#{url_query(branch)}"
      path += "&page-token=#{URI.encode_www_form_component(page_token)}" if page_token
      data = circleci_get(path, token)
      items = data.fetch('items', [])
      pipelines.concat(items)
      oldest = items.filter_map { |pipeline| Time.parse(pipeline.fetch('created_at')) }.min
      page_token = data['next_page_token']
      break if items.empty? || page_token.nil? || (oldest && oldest < @previous_start)
    end
    pipelines
  end

  def circleci_workflows(pipelines, token)
    pipelines.flat_map do |pipeline|
      circleci_get("/pipeline/#{pipeline.fetch('id')}/workflow", token).fetch('items', []).map do |workflow|
        workflow.merge('pipeline_created_at' => pipeline.fetch('created_at'),
                       'pipeline_number' => pipeline.fetch('number'))
      end
    end
  end

  def circleci_jobs(workflows, token)
    workflows.flat_map do |workflow|
      circleci_get("/workflow/#{workflow.fetch('id')}/job", token).fetch('items', []).map do |job|
        job.merge('workflow_id' => workflow.fetch('id'), 'workflow_created_at' => workflow.fetch('created_at'))
      end
    end
  end

  def circleci_get(path, token)
    http_json("https://circleci.com/api/v2#{path}", 'Circle-Token' => token)
  end

  def circleci_token
    token = ENV['CIRCLE_TOKEN'] || ENV.fetch('CIRCLECI_TOKEN', nil)
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

  def summary_branch(owner_repo)
    return @branch if @branch

    branch = git('symbolic-ref', '--quiet', '--short', 'refs/remotes/origin/HEAD', allow_failure: true)
             .strip
             .sub(%r{\Aorigin/}, '')
    return branch unless branch.empty?

    if command_available?('gh')
      branch = gh_json('repo', 'view', owner_repo, '--json', 'defaultBranchRef')
               .dig('defaultBranchRef', 'name')
      return branch if branch && !branch.empty?
    end

    git('branch', '--show-current').strip
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

  def within?(time, start_time, end_time)
    time >= start_time && time < end_time
  end

  def median(values)
    sorted = values.compact.sort
    return nil if sorted.empty?

    sorted.length.odd? ? sorted[sorted.length / 2] : (sorted[(sorted.length / 2) - 1] + sorted[sorted.length / 2]) / 2.0
  end

  def percentile(values, percent)
    sorted = values.compact.sort
    return nil if sorted.empty?

    sorted[[(sorted.length * percent).ceil - 1, 0].max]
  end

  def average(values)
    return nil if values.empty?

    values.sum / values.length
  end

  def skipped(reason)
    { status: 'skipped', reason: reason }
  end

  def unavailable(reason)
    { status: 'unavailable', reason: reason }
  end
end

options = {
  repo_path: Dir.pwd,
  timezone: ENV.fetch('TZ', 'Europe/Berlin'),
  include_jobs: false
}

OptionParser.new do |parser|
  parser.banner = 'Usage: collect.rb [options]'
  parser.on('--repo PATH', 'Repository path. Defaults to the current directory.') do |value|
    options[:repo_path] = value
  end
  parser.on('--timezone TZ', 'Timezone for default windows. Defaults to TZ or Europe/Berlin.') do |value|
    options[:timezone] = value
  end
  parser.on('--current-start TIME', 'Current window start.') { |value| options[:current_start] = value }
  parser.on('--current-end TIME', 'Current window end.') { |value| options[:current_end] = value }
  parser.on('--previous-start TIME', 'Comparison window start. Defaults to one window before current start.') do |value|
    options[:previous_start] = value
  end
  parser.on('--branch BRANCH', 'CircleCI branch. Defaults to the repository default branch.') do |value|
    options[:branch] = value
  end
  parser.on('--include-jobs', 'Collect CircleCI job-level data for library repos.') { options[:include_jobs] = true }
end.parse!

puts ProductivityCollector.new(options).call

# rubocop:enable Metrics/ClassLength, Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
