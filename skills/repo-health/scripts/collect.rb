#!/usr/bin/env ruby
# frozen_string_literal: true

lib = File.expand_path('../../../lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'skills'

# Collects read-only repository health evidence from local and remote
# sources, then prints a JSON document for the skill to summarize.
class RepoHealthCollector
  TREND_WINDOW_COUNT = 4
  STALE_PR_SECONDS = 7 * 24 * 60 * 60
  SOURCE_NAMES = %i[local github circleci digitalocean kubernetes uptimerobot].freeze
  DEFAULT_OVERALL_TIMEOUT_SECONDS = 240
  CI_SUCCESS_RATE_ACTION_THRESHOLD = 0.90
  CHANGE_RATIO_ACTION_THRESHOLD = 0.25
  LIBRARY_RELEASE_AGE_ACTION_SECONDS = 90 * 24 * 60 * 60

  def initialize(options)
    @repo_path = File.expand_path(options.fetch(:repo_path))
    @timezone = options.fetch(:timezone)
    @branch = options[:branch]
    @include_jobs = options.fetch(:include_jobs)
    @source_names = source_names(options.fetch(:source_names))
    @overall_timeout_seconds = options.fetch(:overall_timeout_seconds)
    @now = options[:now] ? parse_time(options[:now]) : Time.now
    @current_end = options[:current_end] ? parse_time(options[:current_end]) : day_start(@now)
    @current_start =
      options[:current_start] ? parse_time(options[:current_start]) : subtract_local_days(@current_end, 7)
    @previous_end = @current_start
    @previous_start = options[:previous_start] ? parse_time(options[:previous_start]) : default_previous_start
    @command = Skills::Command.new
    @git = Skills::Git.new(@repo_path, command: @command)
    @github = Skills::GitHub.new(command: @command)
    @kubernetes = Skills::Kubernetes.new(command: @command)
    @circleci = {}
  end

  def call
    started_at = monotonic_time
    progress('collector started')
    root = @git.root
    owner_repo = Skills::GitHub.repository_from_remote(@git.origin_url)
    branch = summary_branch(owner_repo, @source_names.include?(:github))
    mode = File.exist?(File.join(root, '.cd')) ? 'service' : 'library'
    period = window_seconds <= 24 * 60 * 60 ? 'daily' : 'weekly'
    source_definitions = [
      [:local, -> { collect_local(root) }],
      [:github, -> { collect_github(owner_repo) }],
      [:circleci, -> { collect_circleci(owner_repo, branch, mode, root) }],
      [:digitalocean, lambda do
        mode == 'service' ? collect_digitalocean : skipped('not a service repo')
      end],
      [:kubernetes, lambda do
        if mode == 'service'
          collect_kubernetes(owner_repo.split('/').last)
        else
          skipped('not a service repo')
        end
      end],
      [:uptimerobot, lambda do
        if mode == 'service'
          collect_uptimerobot(owner_repo.split('/').last)
        else
          skipped('not a service repo')
        end
      end]
    ]
    sources = collect_selected_sources(source_definitions)

    result = {
      repository: owner_repo,
      repo_path: root,
      branch: branch,
      mode: "#{mode} #{period} summary",
      timezone: @timezone,
      window: window_hash(@current_start, @current_end),
      comparison_window: window_hash(@previous_start, @previous_end),
      local: sources.fetch(:local),
      github: sources.fetch(:github),
      circleci: sources.fetch(:circleci),
      digitalocean: sources.fetch(:digitalocean),
      kubernetes: sources.fetch(:kubernetes),
      uptimerobot: sources.fetch(:uptimerobot)
    }

    JSON.pretty_generate(summary_result(result))
  ensure
    progress("collector completed after #{format_elapsed(monotonic_time - started_at)}") if started_at
  end

  private

  def parse_time(value)
    with_timezone { Time.parse(value) }
  end

  def source_names(names)
    unknown_names = names - SOURCE_NAMES
    raise ArgumentError, "unknown sources: #{unknown_names.join(', ')}" unless unknown_names.empty?
    raise ArgumentError, 'at least one source must be selected' if names.empty?

    names
  end

  def collect_selected_sources(definitions)
    selected = definitions.to_h.slice(*@source_names).to_a
    collected = Skills::Collection.call(
      selected,
      overall_timeout_seconds: @overall_timeout_seconds,
      on_start: method(:progress_source_start),
      on_finish: method(:progress_source_finish)
    ) { |error| unavailable_for_error(error) }
    definitions.to_h do |name, _|
      [name, collected.fetch(name, skipped('not selected'))]
    end
  end

  def unavailable_for_error(error)
    Skills::SourceStatus.unavailable_for(error)
  end

  def unavailable_source?(value)
    Skills::SourceStatus.unavailable?(value)
  end

  def skipped(reason)
    Skills::SourceStatus.skipped(reason)
  end

  def unavailable(reason)
    Skills::SourceStatus.unavailable(reason)
  end

  def circleci_source(token)
    @circleci[token] ||= Skills::CircleCI.new(token)
  end

  def collect_digitalocean
    source = Skills::DigitalOcean.from_environment
    return unavailable('DIGITALOCEAN_ACCESS_TOKEN is not set') unless source

    clusters = source.kubernetes_clusters
    summaries = clusters.map { |cluster| cluster.slice('name', 'region', 'version', 'status', 'created_at') }
    { status: 'used', clusters: summaries }
  rescue StandardError => e
    unavailable_for_error(e)
  end

  def collect_kubernetes(name)
    return unavailable('kubectl is not installed') unless @kubernetes.available?

    { status: 'used' }.merge(@kubernetes.workload(name))
  rescue StandardError => e
    unavailable_for_error(e)
  end

  def progress_source_start(name)
    progress("source #{name} started")
  end

  def progress_source_finish(name, result, elapsed_seconds)
    status = result.is_a?(Hash) && result[:status] ? result[:status] : 'used'
    detail = result.is_a?(Hash) ? result[:reason] : nil
    message = "source #{name} completed after #{format_elapsed(elapsed_seconds)} with status #{status}"
    progress(detail ? "#{message}: #{detail}" : message)
  end

  def progress(message)
    @progress_lock ||= Mutex.new
    @progress_lock.synchronize do
      warn("repo-health: #{message}")
      $stderr.flush
    end
  rescue Errno::EPIPE
    nil
  end

  def format_elapsed(seconds)
    format('%.3fs', seconds)
  end

  def monotonic_time
    Process.clock_gettime(Process::CLOCK_MONOTONIC)
  end

  def day_start(time)
    with_timezone do
      local = Time.local(time.year, time.month, time.day)
      Time.parse(local.strftime('%Y-%m-%d 00:00:00 %z'))
    end
  end

  # Subtracts whole local calendar days while preserving wall-clock
  # hour/minute/second, so the result lands on local midnight (or whatever
  # time-of-day was given) even across a daylight-saving transition, instead
  # of drifting by the transition's offset change like fixed-second
  # subtraction would.
  def subtract_local_days(time, days)
    date = Date.new(time.year, time.month, time.day) - days
    with_timezone do
      local = Time.local(date.year, date.month, date.day, time.hour, time.min, time.sec)
      Time.parse(local.strftime('%Y-%m-%d %H:%M:%S %z'))
    end
  end

  # Whole calendar-day span between two local times, or nil when they do not
  # share a time-of-day (an explicit arbitrary-instant window), in which case
  # callers fall back to elapsed-second arithmetic.
  def local_day_span(start_time, end_time)
    same_time_of_day = [start_time.hour, start_time.min, start_time.sec] == [end_time.hour, end_time.min, end_time.sec]
    return nil unless same_time_of_day

    end_date = Date.new(end_time.year, end_time.month, end_time.day)
    start_date = Date.new(start_time.year, start_time.month, start_time.day)
    (end_date - start_date).to_i
  end

  def default_previous_start
    days = local_day_span(@current_start, @current_end)
    return @previous_end - window_seconds unless days

    subtract_local_days(@previous_end, days)
  end

  def default_window_start(end_time)
    days = local_day_span(@current_start, @current_end)
    return elapsed_window_start(end_time) unless days

    subtract_local_days(end_time, days)
  end

  def elapsed_window_start(end_time)
    with_timezone do
      time = Time.at(end_time.to_i - window_seconds)
      time.getlocal(time.utc_offset)
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
      trend: period_windows.map { |window| local_period(window.fetch(:start), window.fetch(:end)) },
      release_state: local_release_state,
      circleci_config: circleci_config(root)
    }
  end

  def local_period(start_time, end_time)
    commits = @git.commits_between(start_time, end_time)
    tags = @git.tags_between(start_time, end_time)

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

  def local_release_state
    latest = @git.latest_tag
    return { latest_tag: nil, unreleased_commit_count: @git.commit_count } unless latest

    tag = latest.fetch(:tag)
    created_at = latest.fetch(:created_at)
    {
      latest_tag: tag,
      latest_tag_created_at: created_at,
      latest_release_age_seconds: @now - Time.parse(created_at),
      unreleased_commit_count: @git.commit_count("#{tag}..HEAD")
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
  rescue Psych::SyntaxError
    { present: true, error: 'invalid CircleCI configuration' }
  end

  def collect_github(owner_repo)
    return skipped('gh is not installed') unless @github.available?

    open_state = github_open_prs_at_end(owner_repo)
    trend = period_windows.map { |window| github_period(owner_repo, window.fetch(:start), window.fetch(:end)) }

    {
      current: trend[0],
      previous: trend[1],
      trend: trend,
      open_pr_count: open_state.fetch(:open).length,
      open_prs: open_state.fetch(:open),
      stale_pr_count: open_state.fetch(:stale)&.length,
      stale_prs: open_state.fetch(:stale)
    }
  rescue StandardError => e
    unavailable_for_error(e)
  end

  # Reconstructs which PRs were open at @current_end from complete creation
  # and closed timestamps, since the live open-PR queue reflects collection
  # time, not a historical period end. Stale classification is reliable only
  # when a PR's last known activity is at or before @current_end; otherwise
  # activity could have happened after the boundary, so staleness is reported
  # as unavailable rather than reused from the live `updatedAt`.
  def github_open_prs_at_end(owner_repo)
    candidates = @github.open_pull_requests_before(owner_repo, @current_end)
    open_prs = candidates.select do |pr|
      Time.parse(pr.fetch('createdAt')) <= @current_end &&
        (pr['closedAt'].nil? || Time.parse(pr.fetch('closedAt')) > @current_end)
    end

    known_activity = open_prs.map { |pr| pr['updatedAt'] && Time.parse(pr.fetch('updatedAt')) }
    return { open: open_prs, stale: nil } if known_activity.any? { |updated| updated.nil? || updated > @current_end }

    stale = open_prs.zip(known_activity).select { |_, updated| updated < @current_end - STALE_PR_SECONDS }.map(&:first)
    { open: open_prs, stale: stale }
  end

  def github_period(owner_repo, start_time, end_time)
    merged = @github.merged_pull_requests_between(owner_repo, start_time, end_time)
                    .select { |pr| within?(Time.parse(pr.fetch('mergedAt')), start_time, end_time) }

    created = @github
              .pull_requests_created_between(owner_repo, start_time, end_time)
              .count { |pr| within?(Time.parse(pr.fetch('createdAt')), start_time, end_time) }

    closed_unmerged = @github.unmerged_pull_requests_closed_between(owner_repo, start_time, end_time).count do |pr|
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
      merged_prs: merged.map { |pr| pr.slice('number', 'title', 'createdAt', 'mergedAt', 'url') }
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

    token = Skills::CircleCI.token
    return unavailable('CircleCI token not found') if token.nil? || token.empty?

    source = circleci_source(token)
    pipelines = source.project_pipelines_since(owner_repo, branch, since: period_windows.last.fetch(:start))
    workflows = source.workflows_for(pipelines)
    jobs = @include_jobs || mode == 'service' ? source.jobs_for(workflows) : []
    flaky = source.flaky_tests(owner_repo)
    trend = period_windows.map { |window| circleci_period(workflows, jobs, window.fetch(:start), window.fetch(:end)) }

    {
      current: trend[0],
      previous: trend[1],
      trend: trend,
      flaky_tests: {
        total: flaky['total_flaky_tests'],
        examples: flaky.fetch('flaky_tests', []).map do |test|
          test.slice('classname', 'test_name', 'times_flaked', 'workflow_name', 'job_name', 'workflow_created_at')
        end
      },
      config: root_config,
      pipelines_collected: pipelines.length,
      workflows_collected: workflows.length,
      jobs_collected: jobs.length
    }
  rescue StandardError => e
    unavailable_for_error(e)
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
      failed_workflows: failed.map { |workflow| workflow.slice('name', 'status', 'created_at') },
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
        failed_jobs: failed.map { |job| job.slice('status', 'started_at', 'created_at') }
      }
    end
  end

  def collect_uptimerobot(name)
    source = Skills::UptimeRobot.from_environment
    return unavailable('UPTIMEROBOT_API_KEY is not set') unless source

    ranges = period_windows.map { |window| "#{window.fetch(:start).to_i}_#{window.fetch(:end).to_i}" }.join('-')
    params = {
      'logs' => '1',
      'response_times' => '1',
      'custom_uptime_ranges' => ranges
    }
    monitor = source.monitor(name, params:).fetch(:monitor)
    return unavailable("no UptimeRobot monitor matched #{name}") unless monitor

    samples = monitor.fetch('response_times', [])
    current_samples = response_samples(samples, @current_start, @current_end)
    previous_samples = response_samples(samples, @previous_start, @previous_end)
    response_averages = period_windows.map do |window|
      average(response_samples(samples, window.fetch(:start), window.fetch(:end)))
    end

    {
      status: 'used',
      monitor: monitor.slice('id', 'friendly_name', 'url', 'status'),
      uptime_ranges: monitor['custom_uptime_ranges'] || monitor['custom_uptime_range'],
      logs: monitor.fetch('logs', []),
      current_response_time_average_ms: average(current_samples),
      current_response_time_samples: current_samples.length,
      previous_response_time_average_ms: average(previous_samples),
      previous_response_time_samples: previous_samples.length,
      response_time_average_ms_by_period: response_averages
    }
  rescue StandardError => e
    unavailable_for_error(e)
  end

  def response_samples(samples, start_time, end_time)
    selected = samples.select do |sample|
      timestamp = sample.fetch('datetime').to_i
      timestamp >= start_time.to_i && timestamp < end_time.to_i
    end
    selected.map { |sample| sample.fetch('value').to_f }
  end

  def summary_result(result)
    delivery_flow = summary_delivery_flow(result)
    ci_quality = summary_ci_quality(result)
    release_and_deploy = summary_release_and_deploy(result)
    service_reliability = summary_service_reliability(result)
    trend_context = summary_trend_context(result)
    action_queue = summary_action_queue(delivery_flow, ci_quality, release_and_deploy, service_reliability)
    data_quality_actions = summary_data_quality_actions(result)

    {
      repository: result[:repository],
      repo_path: result[:repo_path],
      branch: result[:branch],
      mode: result[:mode],
      timezone: result[:timezone],
      window: result[:window],
      comparison_window: result[:comparison_window],
      sources: source_summary(result),
      top_bottleneck: summary_top_bottleneck(action_queue),
      action_queue: action_queue,
      trend_context: trend_context,
      data_quality_actions: data_quality_actions,
      delivery_flow: delivery_flow,
      ci_quality: ci_quality,
      release_and_deploy: release_and_deploy,
      service_reliability: service_reliability,
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
      stale_prs: github_value(github, :stale_prs),
      release_state: result.dig(:local, :release_state)
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
      trend: circleci[:trend]&.map { |period| summary_ci_period(period) },
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
      previous: summary_release_period(result.dig(:local, :previous), result.dig(:circleci, :previous)),
      release_state: result.dig(:local, :release_state)
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
      current_incident_count: incident_logs(uptimerobot[:logs], @current_start, @current_end).length,
      previous_incident_count: incident_logs(uptimerobot[:logs], @previous_start, @previous_end).length,
      current_downtime_seconds: downtime_seconds(uptimerobot[:logs], @current_start, @current_end),
      previous_downtime_seconds: downtime_seconds(uptimerobot[:logs], @previous_start, @previous_end),
      current_mttr_seconds: mttr_seconds(uptimerobot[:logs], @current_start, @current_end),
      previous_mttr_seconds: mttr_seconds(uptimerobot[:logs], @previous_start, @previous_end),
      current_response_time_average_ms: uptimerobot[:current_response_time_average_ms],
      current_response_time_samples: uptimerobot[:current_response_time_samples],
      previous_response_time_average_ms: uptimerobot[:previous_response_time_average_ms],
      previous_response_time_samples: uptimerobot[:previous_response_time_samples],
      trend: summary_uptimerobot_trend(uptimerobot)
    }
  end

  def summary_trend_context(result)
    {
      window_count: TREND_WINDOW_COUNT,
      windows: trend_window_summary,
      delivery_flow: trend_metrics(summary_delivery_trend(result), {
                                     commit_count: :neutral,
                                     pr_merged: :neutral,
                                     median_pr_age_seconds: :lower,
                                     median_review_latency_seconds: :lower
                                   }),
      ci_quality: trend_metrics(summary_ci_trend(result), {
                                  workflow_success_rate: :higher,
                                  workflows_failed: :lower,
                                  p95_workflow_duration_seconds: :lower
                                }),
      release_and_deploy: trend_metrics(summary_release_trend(result), {
                                          tag_count: :neutral,
                                          deploy_job_failed: :lower,
                                          rollback_or_revert_count: :lower
                                        }),
      service_reliability: trend_metrics(summary_service_reliability_trend(result), {
                                           uptime: :higher,
                                           incident_count: :lower,
                                           response_time_average_ms: :lower,
                                           downtime_seconds: :lower
                                         })
    }
  end

  def summary_action_queue(delivery_flow, ci_quality, release_and_deploy, service_reliability)
    actions = []
    actions.concat(delivery_actions(delivery_flow))
    actions.concat(ci_actions(ci_quality))
    actions.concat(release_actions(release_and_deploy))
    actions.concat(reliability_actions(service_reliability))
    actions.sort_by { |action| [priority_rank(action.fetch(:priority)), action.fetch(:area)] }
  end

  def summary_top_bottleneck(action_queue)
    action = action_queue.first
    return nil unless action

    pick_symbol(action, :priority, :area, :evidence, :suggested_action)
  end

  def summary_data_quality_actions(result)
    actions = []
    sources = source_summary(result)
    actions << data_quality_action('GitHub', sources[:github], 'PR, review, release, and stale-queue metrics',
                                   'Ensure GitHub API access and authenticate `gh` or set `GITHUB_TOKEN`/`GH_TOKEN`.')
    actions << data_quality_action(
      'CircleCI',
      sources[:circleci],
      'workflow reliability, duration, deploy, and flaky-test metrics',
      'Ensure CircleCI API access and set `CIRCLE_TOKEN`/`CIRCLECI_TOKEN` or configure the CLI token.'
    )

    if result[:mode].start_with?('service')
      actions << data_quality_action(
        'UptimeRobot',
        sources[:uptimerobot],
        'external uptime, incident, MTTR, and response-time metrics',
        'Ensure UptimeRobot API access and set `UPTIMEROBOT_API_KEY` plus `UPTIMEROBOT_MONITOR_IDS`.'
      )
      actions << data_quality_action('Kubernetes', sources[:kubernetes], 'runtime image, readiness, and restart state',
                                     'Ensure `kubectl` can reach the target cluster context.')
      actions << data_quality_action('DigitalOcean', sources[:digitalocean], 'cluster inventory and platform state',
                                     'Ensure DigitalOcean API access and set `DIGITALOCEAN_ACCESS_TOKEN`.')
    end

    actions.compact
  end

  def summary_delivery_trend(result)
    github = result[:github]
    local_periods = result.dig(:local, :trend) || []
    github_periods = summary_github_period(github, :trend) || []
    period_count = [local_periods.length, github_periods.length].max

    period_count.times.map do |index|
      summary_delivery_period(local_periods[index], github_periods[index])
    end
  end

  def summary_ci_trend(result)
    circleci = result[:circleci]
    return [] if unavailable_source?(circleci)

    circleci.fetch(:trend, []).map { |period| summary_ci_period(period) }
  end

  def summary_release_trend(result)
    local_periods = result.dig(:local, :trend) || []
    circleci_periods = result.dig(:circleci, :trend) || []
    period_count = [local_periods.length, circleci_periods.length].max

    period_count.times.map do |index|
      summary_release_period(local_periods[index], circleci_periods[index]).tap do |period|
        period[:deploy_job_failed] = period.dig(:deploy_job, :failed)
      end
    end
  end

  def summary_service_reliability_trend(result)
    uptimerobot = result[:uptimerobot]
    return [] if unavailable_source?(uptimerobot)

    summary_uptimerobot_trend(uptimerobot)
  end

  def summary_uptimerobot_trend(uptimerobot)
    uptimes = uptime_ranges(uptimerobot)
    response_averages = uptimerobot[:response_time_average_ms_by_period] || []
    period_windows.map.with_index do |window, index|
      {
        uptime: numeric(uptimes[index]),
        incident_count: incident_logs(uptimerobot[:logs], window.fetch(:start), window.fetch(:end)).length,
        downtime_seconds: downtime_seconds(uptimerobot[:logs], window.fetch(:start), window.fetch(:end)),
        mttr_seconds: mttr_seconds(uptimerobot[:logs], window.fetch(:start), window.fetch(:end)),
        response_time_average_ms: response_averages[index]
      }
    end
  end

  def trend_metrics(periods, metrics)
    metrics.to_h do |metric, direction|
      [metric, trend_metric(periods, metric, direction)]
    end
  end

  def trend_metric(periods, metric, direction)
    values = periods.map { |period| period && period[metric] }
    current = values[0]
    previous = values[1]
    four_window_median = median(values)
    {
      current: current,
      previous: previous,
      four_window_median: four_window_median,
      delta_from_median: current && four_window_median ? current - four_window_median : nil,
      signal: trend_signal(current, four_window_median, direction)
    }
  end

  def trend_signal(current, baseline, direction)
    return 'n/a' if current.nil? || baseline.nil?

    delta = current - baseline
    return 'flat' if delta.zero?
    return delta.positive? ? 'up' : 'down' if direction == :neutral

    better = direction == :higher ? delta.positive? : delta.negative?
    better ? 'better' : 'worse'
  end

  def delivery_actions(delivery_flow)
    return [] if unavailable_source?(delivery_flow)

    current = delivery_flow[:current] || {}
    previous = delivery_flow[:previous] || {}
    actions = []

    if delivery_flow[:stale_pr_count].to_i.positive?
      actions << action('P2', 'Review', "#{delivery_flow[:stale_pr_count]} open PR(s) stale for more than 7 days.",
                        'Close, merge, or revive each stale PR.')
    end
    if worsened?(current[:median_pr_age_seconds], previous[:median_pr_age_seconds], :lower)
      evidence = "Median PR age rose from #{format_duration(previous[:median_pr_age_seconds])} " \
                 "to #{format_duration(current[:median_pr_age_seconds])}."
      actions << action('P2', 'Delivery', evidence,
                        'Inspect the oldest merged and open PRs for review, CI, or release blockers.')
    end
    if worsened?(current[:median_review_latency_seconds], previous[:median_review_latency_seconds], :lower)
      evidence = "Median review latency rose from #{format_duration(previous[:median_review_latency_seconds])} " \
                 "to #{format_duration(current[:median_review_latency_seconds])}."
      actions << action('P2', 'Review', evidence, 'Assign first-review ownership for active PRs.')
    end

    actions
  end

  def ci_actions(ci_quality)
    return [] if unavailable_source?(ci_quality)

    current = ci_quality[:current] || {}
    previous = ci_quality[:previous] || {}
    actions = []
    success_rate = current[:workflow_success_rate]

    if success_rate && success_rate < CI_SUCCESS_RATE_ACTION_THRESHOLD
      evidence = "Workflow success rate is #{format_rate(success_rate)} " \
                 "with #{current[:workflows_failed].to_i} failed workflow(s)."
      actions << action('P1', 'CI', evidence,
                        'Inspect the latest failed workflows before merging or releasing.')
    elsif current[:workflows_failed].to_i.positive?
      actions << action('P2', 'CI', "#{current[:workflows_failed]} workflow(s) failed in the window.",
                        'Triage failed workflows and confirm reruns were not hiding a persistent failure.')
    end
    if worsened?(current[:p95_workflow_duration_seconds], previous[:p95_workflow_duration_seconds], :lower)
      evidence = "p95 workflow duration rose from #{format_duration(previous[:p95_workflow_duration_seconds])} " \
                 "to #{format_duration(current[:p95_workflow_duration_seconds])}."
      actions << action('P3', 'CI', evidence,
                        'Check the slowest workflows for dependency, cache, or test-runtime regressions.')
    end
    if ci_quality.dig(:flaky_tests, :total).to_i.positive?
      actions << action('P2', 'Tests', "#{ci_quality.dig(:flaky_tests, :total)} flaky test(s) reported by CircleCI.",
                        'Fix or quarantine the named flaky tests before relying on green reruns.')
    end

    actions
  end

  def release_actions(release_and_deploy)
    current = release_and_deploy[:current] || {}
    release_state = release_and_deploy[:release_state] || {}
    deploy_job = current[:deploy_job] || {}
    actions = []

    if deploy_job[:failed].to_i.positive?
      actions << action('P1', 'Deploy', "`deploy` failed #{deploy_job[:failed]} time(s).",
                        'Inspect failed deploy jobs before the next release.')
    end
    if current[:rollback_or_revert_count].to_i.positive?
      actions << action('P1', 'Release', "#{current[:rollback_or_revert_count]} revert or rollback commit(s) found.",
                        'Review the reverted changes and confirm the release path is stable.')
    end
    if release_state[:unreleased_commit_count].to_i.positive? && current[:tag_count].to_i.zero?
      priority = release_state[:latest_release_age_seconds].to_i > LIBRARY_RELEASE_AGE_ACTION_SECONDS ? 'P2' : 'P3'
      evidence = "#{release_state[:unreleased_commit_count]} commit(s) " \
                 "since latest tag #{release_state[:latest_tag] || 'n/a'}."
      actions << action(priority, 'Release', evidence, 'Decide whether the accumulated changes need a release.')
    end

    actions
  end

  def reliability_actions(service_reliability)
    actions = []
    kubernetes = service_reliability[:kubernetes]
    uptimerobot = service_reliability[:uptimerobot]

    unless unavailable_source?(kubernetes)
      if kubernetes[:pod_count].to_i.positive? && kubernetes[:ready_pod_count].to_i < kubernetes[:pod_count].to_i
        actions << action('P1', 'Runtime', "#{kubernetes[:ready_pod_count]}/#{kubernetes[:pod_count]} pod(s) ready.",
                          'Inspect the non-ready pods and rollout status.')
      end
      if kubernetes[:pod_restart_count].to_i.positive?
        evidence = "#{kubernetes[:pod_restart_count]} pod/container restart(s) observed at collection time."
        actions << action('P2', 'Runtime', evidence,
                          'Check recent pod events and logs for recurring crashes.')
      end
    end

    unless unavailable_source?(uptimerobot)
      current_uptime = numeric(uptimerobot[:current_uptime])
      if current_uptime && current_uptime < 99.9
        actions << action('P1', 'Reliability', "External uptime is #{current_uptime}%.",
                          'Review downtime logs and confirm whether the incident is resolved.')
      end
      if uptimerobot[:current_incident_count].to_i.positive?
        actions << action('P1', 'Reliability', "#{uptimerobot[:current_incident_count]} incident(s) in the window.",
                          'Review incident windows, MTTR, and any overlapping deploys.')
      end
      if worsened?(
        uptimerobot[:current_response_time_average_ms],
        uptimerobot[:previous_response_time_average_ms],
        :lower
      )
        evidence = "Average response time rose from #{format_ms(uptimerobot[:previous_response_time_average_ms])} " \
                   "to #{format_ms(uptimerobot[:current_response_time_average_ms])}."
        actions << action('P2', 'Reliability', evidence,
                          'Check recent deploys, saturation, and external dependency latency.')
      end
    end

    actions
  end

  def data_quality_action(source, status, impact, setup_action)
    return nil if status.nil? || status[:status] == 'used'
    return nil if ['not a service repo', 'no .circleci/config.yml'].include?(status[:notes])

    {
      source: source,
      status: status[:status],
      reason: status[:notes],
      impact: impact,
      setup_action: setup_action
    }
  end

  def action(priority, area, evidence, suggested_action)
    {
      priority: priority,
      area: area,
      evidence: evidence,
      suggested_action: suggested_action
    }
  end

  def priority_rank(priority)
    { 'P1' => 1, 'P2' => 2, 'P3' => 3 }.fetch(priority, 9)
  end

  def worsened?(current, previous, direction)
    return false if current.nil? || previous.nil?
    return current.positive? if previous.zero? && direction == :lower
    return current < previous if previous.zero? && direction == :higher

    ratio = (current - previous).to_f / previous.abs
    direction == :lower ? ratio > CHANGE_RATIO_ACTION_THRESHOLD : ratio < -CHANGE_RATIO_ACTION_THRESHOLD
  end

  def period_windows
    windows = [
      { start: @current_start, end: @current_end },
      { start: @previous_start, end: @previous_end }
    ]
    while windows.length < TREND_WINDOW_COUNT
      end_time = windows.last.fetch(:start)
      windows << { start: default_window_start(end_time), end: end_time }
    end
    windows
  end

  def trend_window_summary
    labels = %w[current previous minus_2 minus_3]
    period_windows.map.with_index do |window, index|
      { label: labels[index], start: window.fetch(:start).iso8601, end: window.fetch(:end).iso8601 }
    end
  end

  def incident_logs(logs, start_time, end_time)
    Array(logs).select { |log| incident_log?(log) && incident_overlaps?(log, start_time, end_time) }
  end

  def incident_log?(log)
    log['type'].to_i == 1
  end

  def incident_overlaps?(log, start_time, end_time)
    outage_start = incident_start(log)
    return false unless outage_start

    duration = incident_duration(log)
    return within?(outage_start, start_time, end_time) unless duration.positive?

    outage_start < end_time && outage_start + duration > start_time
  end

  def incident_start(log)
    datetime = log['datetime']
    datetime && Time.at(datetime.to_i)
  end

  def incident_duration(log)
    log['duration'].to_i
  end

  def downtime_seconds(logs, start_time, end_time)
    incident_logs(logs, start_time, end_time).sum do |log|
      incident_downtime_seconds(log, start_time, end_time)
    end
  end

  def incident_downtime_seconds(log, start_time, end_time)
    duration = incident_duration(log)
    return 0 unless duration.positive?

    outage_start = incident_start(log)
    outage_end = outage_start + duration
    [[outage_end, end_time].min - [outage_start, start_time].max, 0].max
  end

  def mttr_seconds(logs, start_time, end_time)
    median(incident_logs(logs, start_time, end_time).filter_map do |log|
      duration = incident_duration(log)
      duration if duration.positive?
    end)
  end

  def numeric(value)
    return nil if value.nil? || value == ''

    Float(value)
  rescue ArgumentError, TypeError
    nil
  end

  def format_duration(seconds)
    return 'n/a' if seconds.nil?

    return "#{(seconds / 86_400.0).round(1)}d" if seconds >= 86_400
    return "#{(seconds / 3_600.0).round(1)}h" if seconds >= 3_600

    "#{(seconds / 60.0).round(1)}m"
  end

  def format_ms(value)
    value ? "#{value.round}ms" : 'n/a'
  end

  def format_rate(value)
    value ? "#{(value * 100).round(1)}%" : 'n/a'
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

  def uptime_ranges(uptimerobot)
    uptimerobot.fetch(:uptime_ranges, '').split('-')
  end

  def pick_symbol(hash, *keys)
    keys.each_with_object({}) { |key, result| result[key] = hash[key] if hash.key?(key) }
  end

  def summary_branch(owner_repo, github_selected)
    return @branch if @branch

    branch = @git.remote_default_branch
    return branch unless branch.empty?

    branch = @github.default_branch(owner_repo) if github_selected
    return branch if branch && !branch.empty?

    @git.current_branch
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
end

options = {
  repo_path: Dir.pwd,
  timezone: ENV.fetch('TZ', 'Europe/Berlin'),
  include_jobs: false,
  source_names: RepoHealthCollector::SOURCE_NAMES,
  overall_timeout_seconds: RepoHealthCollector::DEFAULT_OVERALL_TIMEOUT_SECONDS
}

OptionParser.new do |parser|
  parser.banner = 'Usage: collect.rb [options]'
  parser.separator 'Windows of 24 hours or less are classified as daily; longer windows are weekly.'
  parser.on('--repo PATH', 'Repository path. Defaults to the current directory.') do |value|
    options[:repo_path] = value
  end
  parser.on('--timezone TZ', 'Timezone for default windows. Defaults to TZ or Europe/Berlin.') do |value|
    options[:timezone] = value
  end
  parser.on('--current-start TIME', 'Window start parsed by Ruby Time.parse; default is 7 days before end.') do |value|
    options[:current_start] = value
  end
  parser.on('--current-end TIME', 'Window end parsed by Ruby Time.parse; default is local day start.') do |value|
    options[:current_end] = value
  end
  parser.on('--previous-start TIME', 'Comparison start parsed by Time.parse; default is one window earlier.') do |value|
    options[:previous_start] = value
  end
  parser.on('--branch BRANCH', 'CircleCI branch. Defaults to the repository default branch.') do |value|
    options[:branch] = value
  end
  parser.on('--include-jobs', 'Collect CircleCI job-level data for library repos.') { options[:include_jobs] = true }
  parser.on('--sources NAMES',
            'Comma-separated sources: local, github, circleci, digitalocean, kubernetes, uptimerobot.') do |value|
    options[:source_names] = value.split(',').map(&:strip).reject(&:empty?).map(&:to_sym)
  end
  parser.on('--timeout SECONDS', Float, 'Overall collection timeout in seconds. Defaults to 240.') do |value|
    raise OptionParser::InvalidArgument, 'timeout must be greater than zero' unless value.positive?

    options[:overall_timeout_seconds] = value
  end
end.parse!

puts RepoHealthCollector.new(options).call
