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
  TERMINAL_WORKFLOW_STATUSES = %w[canceled cancelled error failed success unauthorized].freeze
  CIRCLECI_TEST_RESULT_PAGE_LIMIT = 5
  CIRCLECI_TEST_RESULT_LIMIT = 500
  CIRCLECI_TEST_CLASS_LIMIT = 10
  CIRCLECI_FAILURE_SAMPLE_LIMIT = 5
  CIRCLECI_FAILURE_VALUE_LIMIT = 160
  CIRCLECI_FAILURE_SIGNATURE_LIMIT = 5
  CIRCLECI_REVISION_PIPELINE_LIMIT = 5
  CIRCLECI_REVISION_COMPARISON_LIMIT = 3
  CIRCLECI_FAILURE_TEXT_TRUNCATION_MARKER = ' ... '
  GITHUB_COMMIT_STATUS_LIMIT = 20

  FAILURE_URL_PATTERN = %r{\b(?:https?|s3)://[^\s<>"']+}i
  FAILURE_CREDENTIAL_NAMES = [
    'access[-_ ]?token', 'api[-_ ]?key', 'authorization', 'bearer', 'circle(?:ci)?[-_ ]?token',
    'credential', 'output[-_ ]?url', 'password', 'secret', 'session[-_ ]?token', 'signature', 'token'
  ].freeze
  FAILURE_CREDENTIAL_PATTERN = Regexp.new(
    "(\\b(?:[A-Za-z0-9]+[-_])?(?:#{FAILURE_CREDENTIAL_NAMES.join('|')})[A-Za-z0-9_-]*\\s*" \
    "(?:=|:|\\s)\\s*(?:Bearer\\s+)?)(?:[\"']?)[^\\s,;]+",
    Regexp::IGNORECASE
  )
  FAILURE_ASSIGNMENT_PATTERN = /(\b[A-Za-z_][A-Za-z0-9_-]*\s*=\s*)(?:["']?)[^\s,;]+/
  FAILURE_TOKEN_PATTERN = /
    \b(?:AKIA[0-9A-Z]{16}|(?:ccip|cct|gh[pousr]|github_pat|glpat|npm)_[A-Za-z0-9_-]{16,}|
    (?:sk|rk|pk)_(?:live|test)_[A-Za-z0-9_-]{16,}|xox[baprs]-[A-Za-z0-9-]{16,}|
    [A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]{10,})\b
  /x
  SENSITIVE_OUTPUT_KEYS = %w[logs messages output_url url web_url].freeze

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

    JSON.pretty_generate(sanitized_output(result))
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
    revision_comparison = if @revision
                            identical_tree_revision_comparison(
                              owner_repo, revision, pull_requests_for_revision, circleci
                            )
                          end

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

    evidence = { github: github, circleci: circleci }
    evidence[:revision_comparison] = revision_comparison if revision_comparison

    diagnosis_metadata(root, owner_repo).merge(
      target: target,
      sources: sources,
      findings: findings,
      evidence: evidence
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

    selection = circleci_revision_pipeline_selection(owner_repo, revision, token) if @revision
    pipeline = selection&.fetch(:pipeline, nil)
    if pipeline.nil?
      pipeline = if @pipeline
                   circleci_pipeline_target(owner_repo, @pipeline, token)
                 else
                   latest_circleci_pipeline(owner_repo, branch, token)
                 end
    end
    fallback = circleci_commit_status_fallback(owner_repo, revision) if @revision && pipeline.nil?
    return fallback if fallback
    return unavailable(circleci_pipeline_not_found_reason(branch)) unless pipeline

    collect_circleci_pipeline(
      owner_repo,
      pipeline,
      token,
      workflows: selection&.fetch(:workflows, nil),
      pipeline_selection: selection&.fetch(:metadata, nil)
    )
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

  def collect_circleci_pipeline(owner_repo, pipeline, token, workflows: nil, pipeline_selection: nil)
    workflows ||= circleci_workflows(pipeline.fetch('id'), token)
    jobs = circleci_jobs(owner_repo, workflows, token)
    result = {
      status: 'used',
      pipeline: pipeline_summary(pipeline),
      workflows: workflows.map { |workflow| workflow_summary(workflow) },
      workflow_attempts: workflow_attempt_groups(workflows),
      jobs: jobs.map { |job| job_summary(job) },
      recurring_failure_signatures: summarized_failure_signatures(jobs, workflows),
      failed_workflows: workflows.select { |workflow| failed_circleci_workflow?(workflow) }.map do |workflow|
        workflow_summary(workflow)
      end,
      active_workflows: workflows.select { |workflow| active_circleci_workflow?(workflow) }.map do |workflow|
        workflow_summary(workflow)
      end,
      failed_jobs: jobs.select { |job| failed_circleci_job?(job) }.map { |job| job_summary(job) },
      deploy_job: jobs.find { |job| job['name'] == 'deploy' }&.then { |job| job_summary(job) }
    }
    result[:pipeline_selection] = pipeline_selection if pipeline_selection
    result
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
                'Inspect the CircleCI job details.')
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
    finding('failure', 'circleci-job', evidence, "Inspect #{job[:name]} job details.")
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
             'Inspect deploy job details before checking runtime state.')]
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

  def circleci_revision_pipeline_selection(owner_repo, revision, token)
    pipelines, scan = circleci_pipelines_by_revision(owner_repo, revision, token)
    return nil if pipelines.empty?

    candidates = pipelines.map { |pipeline| revision_pipeline_candidate(pipeline, token) }
    selected = candidates.max_by { |candidate| revision_pipeline_rank(candidate) }
    {
      pipeline: selected.fetch(:pipeline),
      workflows: selected[:workflows],
      workflow_evidence: selected.fetch(:workflow_evidence),
      metadata: revision_pipeline_selection_metadata(revision, candidates, selected, scan)
    }
  end

  def circleci_pipelines_by_revision(owner_repo, revision, token)
    matches = []
    observed_matching_pipeline_count = 0
    page_token = nil
    50.times do
      path = "/project/gh/#{owner_repo}/pipeline"
      path += "?page-token=#{url_query(page_token)}" if page_token
      data = circleci_get(path, token)
      page_matches = data.fetch('items', []).select { |pipeline| pipeline.dig('vcs', 'revision') == revision }
      observed_matching_pipeline_count += page_matches.length
      matches.concat(page_matches)
      if matches.length > CIRCLECI_REVISION_PIPELINE_LIMIT
        return [
          matches.first(CIRCLECI_REVISION_PIPELINE_LIMIT),
          { observed_matching_pipeline_count: observed_matching_pipeline_count, candidate_scan_truncated: true }
        ]
      end

      page_token = data['next_page_token']
      unless page_token
        return [
          matches,
          { observed_matching_pipeline_count: observed_matching_pipeline_count, candidate_scan_truncated: false }
        ]
      end
    end
    [
      matches,
      { observed_matching_pipeline_count: observed_matching_pipeline_count, candidate_scan_truncated: true }
    ]
  end

  def revision_pipeline_candidate(pipeline, token)
    workflows = circleci_workflows(pipeline.fetch('id'), token)
    evidence = workflow_evidence(workflows)
    { pipeline: pipeline, workflows: workflows, workflow_evidence: evidence }
  rescue StandardError => e
    {
      pipeline: pipeline,
      workflow_evidence: { status: 'unavailable', reason: source_error_reason(e) }
    }
  end

  def revision_pipeline_rank(candidate)
    evidence = candidate.fetch(:workflow_evidence)
    [
      evidence.fetch(:terminal_workflow_count, 0).positive? ? 1 : 0,
      evidence.fetch(:failed_workflow_count, 0).positive? ? 1 : 0,
      evidence.fetch(:terminal_workflow_count, 0),
      evidence.fetch(:workflow_count, 0),
      candidate.fetch(:pipeline).fetch('number', 0).to_i
    ]
  end

  def revision_pipeline_selection_metadata(revision, candidates, selected, scan)
    ordered_candidates = candidates.sort_by { |candidate| -candidate.fetch(:pipeline).fetch('number', 0).to_i }
    {
      status: 'used',
      revision: revision,
      matching_pipeline_count: candidates.length,
      matching_pipeline_truncated: scan.fetch(:candidate_scan_truncated),
      observed_matching_pipeline_count: scan.fetch(:observed_matching_pipeline_count),
      candidate_scan_truncated: scan.fetch(:candidate_scan_truncated),
      selected_pipeline_number: selected.fetch(:pipeline).fetch('number', nil),
      selection_reason: revision_pipeline_selection_reason(selected),
      candidates: ordered_candidates.map do |candidate|
        {
          pipeline: pipeline_summary(candidate.fetch(:pipeline)),
          workflow_evidence: candidate.fetch(:workflow_evidence)
        }
      end
    }
  end

  def revision_pipeline_selection_reason(candidate)
    return 'terminal_workflow_evidence' if candidate.dig(:workflow_evidence, :terminal_workflow_count).to_i.positive?

    'latest_pipeline_without_terminal_workflow_evidence'
  end

  def workflow_evidence(workflows)
    statuses = workflows.group_by { |workflow| workflow_status(workflow) }
                        .sort
                        .to_h { |status, grouped| [status, grouped.length] }
    terminal_statuses = workflows.select { |workflow| terminal_circleci_workflow?(workflow) }
                                 .group_by { |workflow| workflow_status(workflow) }
                                 .sort
                                 .to_h { |status, grouped| [status, grouped.length] }
    {
      status: 'used',
      workflow_count: workflows.length,
      terminal_workflow_count: workflows.count { |workflow| terminal_circleci_workflow?(workflow) },
      failed_workflow_count: workflows.count { |workflow| failed_circleci_workflow?(workflow) },
      active_workflow_count: workflows.count { |workflow| active_circleci_workflow?(workflow) },
      statuses: statuses,
      terminal_statuses: terminal_statuses
    }
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
      status: job_status
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
    enriched = job
    if job['job_number'].nil?
      return enriched unless failed_circleci_job?(job)

      return enriched.merge('failed_step_metadata_limitation' => 'CircleCI did not provide a job number.')
    end
    return enriched unless failed_circleci_job?(job) || (job['name'] == 'deploy' && job['status'] != 'not_run')

    details = circleci_get("/project/gh/#{owner_repo}/job/#{job.fetch('job_number')}", token)
    enriched = enriched.merge(
      'contexts' => details.fetch('contexts', []).map { |context| context['name'] },
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
      results, result_limit_reached = bounded_test_results(results + items)
      pages += 1
      page_token = data['next_page_token']
      page_limit_reached = page_token && pages >= CIRCLECI_TEST_RESULT_PAGE_LIMIT
      truncated ||= result_limit_reached || page_limit_reached
      break if page_token.nil? || page_limit_reached
    end

    { 'test_results' => summarized_test_results(results, truncated) }
  rescue StandardError => e
    { 'test_results' => { 'status' => 'unavailable', 'reason' => source_error_reason(e) } }
  end

  def summarized_test_results(results, truncated)
    failures = results.reject { |result| %w[success skipped].include?(test_result_value(result, 'result')) }
    primary_failures, cascading_failures = classified_test_failures(failures)
    grouped_failures = failures.group_by { |result| test_result_value(result, 'result') }
    grouped_entries = grouped_failures.sort_by do |result, _grouped_results|
      [failure_classification(result, primary_failures.any?) == 'primary' ? 0 : 1, result]
    end
    grouped = grouped_entries.to_h do |result, grouped_results|
      [result, {
        'classification' => failure_classification(result, primary_failures.any?),
        'test_classes' => summarized_test_classes(grouped_results)
      }]
    end
    class_limit_reached = grouped_failures.any? do |_result, grouped_results|
      grouped_results.map { |result| test_result_value(result, 'classname') }.uniq.length > CIRCLECI_TEST_CLASS_LIMIT
    end
    {
      'status' => 'used',
      'total' => failures.length,
      'primary_total' => primary_failures.length,
      'cascading_total' => cascading_failures.length,
      'failures' => grouped.map do |result, summary|
        {
          'result' => result,
          'classification' => summary.fetch('classification'),
          'test_classes' => summary.fetch('test_classes')
        }
      end,
      'failure_samples' => summarized_failure_samples(primary_failures, cascading_failures, truncated),
      'truncated' => truncated || class_limit_reached
    }
  end

  def bounded_test_results(results)
    return [results, false] if results.length <= CIRCLECI_TEST_RESULT_LIMIT

    selected = results.sort_by do |result|
      [
        test_result_priority(test_result_value(result, 'result')),
        test_result_value(result, 'result'),
        test_result_value(result, 'classname'),
        test_result_value(result, 'name'),
        result['message'].to_s
      ]
    end.first(CIRCLECI_TEST_RESULT_LIMIT)
    [selected, true]
  end

  def summarized_failure_samples(primary_failures, cascading_failures, source_truncated)
    selected_failures = primary_failures.empty? ? cascading_failures : primary_failures
    candidates = selected_failures.map { |result| failure_sample(result, primary_failures.any?) }
    candidates.sort_by! { |sample| failure_sample_sort_key(sample) }
    samples = deduplicated_failure_samples(candidates)
    selected = samples.first(CIRCLECI_FAILURE_SAMPLE_LIMIT)
    sample_text_truncated = selected.any? do |sample|
      sample.any? { |key, value| key.end_with?('_truncated') && value }
    end

    {
      'samples' => selected,
      'deduplicated' => samples.length < candidates.length,
      'truncated' => source_truncated || samples.length > selected.length || sample_text_truncated
    }
  end

  def deduplicated_failure_samples(candidates)
    seen = {}
    candidates.filter_map do |sample|
      key = failure_signature_key(sample)
      next if seen[key]

      seen[key] = true
      sample
    end
  end

  def failure_sample(result, primary_present)
    name, name_truncated = sanitized_failure_text(result['name'], CIRCLECI_FAILURE_VALUE_LIMIT)
    classname, classname_truncated = sanitized_failure_text(result['classname'], CIRCLECI_FAILURE_VALUE_LIMIT)
    sample_result, result_truncated = sanitized_failure_text(result['result'], CIRCLECI_FAILURE_VALUE_LIMIT)
    sample = {
      'name' => name || 'unknown',
      'classname' => classname || 'unknown',
      'result' => sample_result || 'unknown',
      'classification' => failure_classification(test_result_value(result, 'result'), primary_present)
    }
    assertion, assertion_truncated = sanitized_assertion(result['message'])
    sample['assertion'] = assertion if assertion
    sample['name_truncated'] = true if name_truncated
    sample['classname_truncated'] = true if classname_truncated
    sample['result_truncated'] = true if result_truncated
    sample['assertion_truncated'] = true if assertion_truncated
    sample
  end

  def classified_test_failures(failures)
    primary_present = failures.any? { |result| primary_test_result?(test_result_value(result, 'result')) }
    failures.partition { |result| !cascading_test_result?(test_result_value(result, 'result'), primary_present) }
  end

  def primary_test_result?(result)
    %w[failure error].include?(result.downcase)
  end

  def cascading_test_result?(result, primary_present)
    primary_present && result.downcase == 'system-err'
  end

  def failure_classification(result, primary_present)
    cascading_test_result?(result, primary_present) ? 'cascading' : 'primary'
  end

  def failure_sample_sort_key(sample)
    [
      sample.fetch('classification') == 'primary' ? 0 : 1,
      test_result_priority(sample.fetch('result')),
      sample.fetch('classname'),
      sample.fetch('name'),
      failure_signature_key(sample)
    ]
  end

  def failure_signature_key(sample)
    [sample['result'], sample['classname'], sample['name'], *sample.fetch('assertion', {}).values]
      .join("\u0000")
      .gsub(/\b\d+\b/, '#')
  end

  def sanitized_assertion(value)
    return [nil, false] if value.nil?

    text = value.to_s.gsub(/\s+/, ' ').strip
    rspec_assertion = rspec_matcher_assertion(text)
    return rspec_assertion if rspec_assertion

    expected, expected_truncated = assertion_value(text, 'expected')
    actual, actual_truncated = assertion_value(text, 'actual|got|but was')
    return [nil, false] unless expected || actual

    assertion = {}.tap do |assertion|
      assertion['expected'] = expected if expected
      assertion['actual'] = actual if actual
    end
    [assertion, expected_truncated || actual_truncated]
  end

  def rspec_matcher_assertion(text)
    match = text.match(/\bexpected\s+(.+?)\s+to be (?:an? )?(?:instance|kind) of\s+([^\s,;]+)/i)
    return nil unless match

    actual, actual_truncated = sanitized_failure_text(match[1], CIRCLECI_FAILURE_VALUE_LIMIT, preserve_ends: true)
    expected, expected_truncated = sanitized_failure_text(match[2], CIRCLECI_FAILURE_VALUE_LIMIT, preserve_ends: true)
    [{ 'actual' => actual, 'expected' => expected }, actual_truncated || expected_truncated]
  end

  def assertion_value(text, labels)
    pattern = "\\b(?:#{labels})\\b\\s*(?::|=)?\\s*" \
              "(\"(?:\\\\.|[^\"\\\\])*\"|'(?:\\\\.|[^'\\\\])*'|<[^>]*>|\\[[^\\]]*\\]|\\{[^}]*\\}|`[^`]*`|[^\\s,;]+)"
    match = text.match(Regexp.new(pattern, Regexp::IGNORECASE))
    return [nil, false] unless match

    sanitized_failure_text(match[1], CIRCLECI_FAILURE_VALUE_LIMIT, preserve_ends: true)
  end

  def test_result_priority(result)
    return 0 if %w[failure error].include?(result.downcase)
    return 2 if result.downcase == 'system-err'

    1
  end

  def sanitized_failure_text(value, limit, preserve_ends: false)
    return [nil, false] if value.nil?

    text = redact_failure_text(value.to_s.gsub(/\s+/, ' ').strip)
    return [nil, false] if text.empty?
    return [text, false] if text.length <= limit

    return ["#{text[0, limit - 3]}...", true] unless preserve_ends

    remaining_length = limit - CIRCLECI_FAILURE_TEXT_TRUNCATION_MARKER.length
    leading_length = (remaining_length + 1) / 2
    trailing_length = remaining_length - leading_length
    excerpt = "#{text[0, leading_length]}#{CIRCLECI_FAILURE_TEXT_TRUNCATION_MARKER}" \
              "#{text[-trailing_length, trailing_length]}"
    [excerpt, true]
  end

  def redact_failure_text(text)
    text.gsub(FAILURE_URL_PATTERN, '[REDACTED_URL]')
        .gsub(FAILURE_CREDENTIAL_PATTERN, '\\1[REDACTED]')
        .gsub(FAILURE_ASSIGNMENT_PATTERN, '\\1[REDACTED]')
        .gsub(FAILURE_TOKEN_PATTERN, '[REDACTED]')
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

  def collect_uptimerobot(name)
    key = ENV.fetch('UPTIMEROBOT_API_KEY', '').strip
    return unavailable('UPTIMEROBOT_API_KEY is not set') if key.empty?

    params = { 'api_key' => key, 'format' => 'json' }
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

    { status: 'used', monitor: symbolize(pick(monitor, 'id', 'friendly_name', 'status')) }
  rescue StandardError => e
    unavailable_for_error(e)
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
                   'workflow_name', 'contexts', 'details_error', 'failed_step',
                   'failed_step_metadata_limitation', 'failed_step_fallback', 'test_results'))
  end

  def github_current_pull_request(owner_repo, branch)
    return skipped('gh is not installed') unless command_available?('gh')
    return nil if branch.nil? || branch.empty?

    gh_json(
      'pr', 'list', '--repo', owner_repo, '--head', branch, '--state', 'open',
      '--json', 'number,title,headRefName,baseRefName,isDraft,mergeStateStatus,reviewDecision'
    ).first
  rescue StandardError => e
    unavailable_for_error(e)
  end

  def github_pull_requests_for_revision(owner_repo, revision)
    return skipped('gh is not installed') unless command_available?('gh')

    gh_json(
      'pr', 'list', '--repo', owner_repo, '--search', revision, '--state', 'all', '--limit', '100',
      '--json', 'number,title,state,headRefName,baseRefName,isDraft,mergedAt,closedAt,mergeCommit'
    )
  rescue StandardError => e
    unavailable_for_error(e)
  end

  def identical_tree_revision_comparison(owner_repo, revision, pull_requests, circleci)
    unless pull_requests.is_a?(Array)
      return skipped('No GitHub pull-request evidence was available for the selected revision.')
    end
    unless circleci[:status] == 'used'
      return skipped('CircleCI pipeline evidence was unavailable for the selected revision.')
    end

    source_tree = revision_tree(revision)
    return skipped('The selected revision is not available locally for tree comparison.') if source_tree.nil?

    pull_requests = merged_pull_requests(pull_requests)
    return skipped('No merged pull request matched the selected revision.') if pull_requests.empty?

    selected = pull_requests.first(CIRCLECI_REVISION_COMPARISON_LIMIT)
    token = circleci_token
    source_workflow_evidence = workflow_evidence(circleci.fetch(:workflows, []))
    {
      status: 'used',
      source_revision: revision,
      source_workflow_evidence: source_workflow_evidence,
      comparisons: selected.map do |pull_request|
        revision_tree_comparison(owner_repo, source_tree, pull_request, token, source_workflow_evidence)
      end,
      truncated: pull_requests.length > selected.length
    }
  end

  def merged_pull_requests(pull_requests)
    pull_requests.select { |pull_request| pull_request['mergedAt'] && pull_request.dig('mergeCommit', 'oid') }
                 .sort_by { |pull_request| [pull_request['mergedAt'], pull_request['number'].to_i] }
                 .reverse
  end

  def revision_tree_comparison(owner_repo, source_tree, pull_request, token, source_workflow_evidence)
    merge_revision = pull_request.dig('mergeCommit', 'oid')
    merge_tree = revision_tree(merge_revision)
    comparison = {
      pr_number: pull_request['number'],
      merge_revision: merge_revision,
      tree_relation: tree_relation(source_tree, merge_tree)
    }
    return comparison unless comparison[:tree_relation] == 'identical'

    comparison.merge(merge_workflow_comparison(owner_repo, merge_revision, token, source_workflow_evidence))
  end

  def merge_workflow_comparison(owner_repo, merge_revision, token, source_workflow_evidence)
    unless token
      return { merge_workflow_evidence: skipped('CircleCI token was unavailable for merge-revision comparison.') }
    end

    selection = circleci_revision_pipeline_selection(owner_repo, merge_revision, token)
    unless selection
      reason = "No CircleCI pipeline found for merge revision #{merge_revision}."
      return { merge_workflow_evidence: unavailable(reason) }
    end

    merge_evidence = selection.fetch(:workflow_evidence)
    {
      merge_workflow_evidence: merge_evidence,
      terminal_outcome_relation: terminal_outcome_relation(source_workflow_evidence, merge_evidence)
    }
  end

  def terminal_outcome_relation(source_evidence, merge_evidence)
    return 'unavailable' unless merge_evidence[:status] == 'used'
    if source_evidence.fetch(:terminal_workflow_count, 0).zero? ||
       merge_evidence.fetch(:terminal_workflow_count, 0).zero?
      return 'no_terminal_evidence'
    end

    if merge_evidence.fetch(:terminal_statuses, {}) == source_evidence.fetch(:terminal_statuses, {})
      'same_terminal_statuses'
    else
      'different_terminal_statuses'
    end
  end

  def tree_relation(source_tree, merge_tree)
    return 'unavailable' if merge_tree.nil?

    merge_tree == source_tree ? 'identical' : 'different'
  end

  def revision_tree(revision)
    tree = git('rev-parse', '--verify', '--end-of-options', "#{revision}^{tree}", allow_failure: true).strip
    tree.empty? ? nil : tree
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

  def job_failed_step(job)
    step = job[:failed_step]
    return '' unless step

    exit_code = step['exit_code']
    suffix = exit_code.nil? ? '' : " with exit code #{exit_code}"
    "; failed step #{step['name']} is #{step['status']}#{suffix}"
  end

  def failed_circleci_job?(job)
    job['stopped_at'] && !%w[success running on_hold not_run].include?(job['status'])
  end

  def failed_circleci_workflow?(workflow)
    FAILED_WORKFLOW_STATUSES.include?(workflow_status(workflow))
  end

  def active_circleci_workflow?(workflow)
    ACTIVE_WORKFLOW_STATUSES.include?(workflow_status(workflow))
  end

  def terminal_circleci_workflow?(workflow)
    return true if TERMINAL_WORKFLOW_STATUSES.include?(workflow_status(workflow))

    !workflow['stopped_at'].nil? || !workflow[:stopped_at].nil?
  end

  def workflow_status(workflow)
    workflow['status'] || workflow[:status] || 'unknown'
  end

  def circleci_pipeline_not_found_reason(branch)
    return "No CircleCI pipeline found for revision #{@revision}." if @revision

    "No CircleCI pipeline found for #{branch}."
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

  def summarized_failure_signatures(jobs, workflows)
    attempts_by_workflow = workflows.to_h do |workflow|
      [workflow.fetch('id'), workflow.fetch('auto_rerun_number', 0).to_i]
    end
    signatures = jobs.select { |job| failed_circleci_job?(job) }.flat_map do |job|
      job_failure_signatures(job, attempts_by_workflow.fetch(job['workflow_id'], 0))
    end
    recurring = signatures.group_by { |signature| signature.fetch(:key) }
                          .filter_map { |_key, occurrences| summarized_recurring_signature(occurrences) }
                          .select { |signature| signature.fetch('occurrences') > 1 }
                          .sort_by do |signature|
      [-signature.fetch('occurrences'), JSON.generate(signature.fetch('signature'))]
    end
    selected = recurring.first(CIRCLECI_FAILURE_SIGNATURE_LIMIT)

    {
      'recurring' => selected,
      'truncated' => recurring.length > selected.length
    }
  end

  def job_failure_signatures(job, workflow_attempt)
    samples = job.dig('test_results', 'failure_samples', 'samples') || []
    samples = [nil] if samples.empty?
    samples.map do |sample|
      signature = {
        'job_name' => sanitized_failure_text(job['name'], CIRCLECI_FAILURE_VALUE_LIMIT).first || 'unknown',
        'failed_step' => sanitized_failure_text(job.dig('failed_step', 'name'), CIRCLECI_FAILURE_VALUE_LIMIT).first,
        'test' => sample&.slice('classname', 'name', 'result', 'assertion')
      }.compact
      { key: JSON.generate(signature), signature: signature, workflow_attempt: workflow_attempt }
    end
  end

  def summarized_recurring_signature(occurrences)
    workflow_attempts = occurrences.map { |occurrence| occurrence.fetch(:workflow_attempt) }.uniq
    {
      'signature' => occurrences.first.fetch(:signature),
      'occurrences' => occurrences.length,
      'workflow_attempt_count' => workflow_attempts.length,
      'rerun_attempt_count' => workflow_attempts.count(&:positive?)
    }
  end

  def sanitized_output(value)
    case value
    when Hash
      value.each_with_object({}) do |(key, nested), output|
        next if SENSITIVE_OUTPUT_KEYS.include?(key.to_s)

        output[key] = sanitized_output(nested)
      end
    when Array
      value.map { |item| sanitized_output(item) }
    when String
      sanitized_failure_text(value, CIRCLECI_FAILURE_VALUE_LIMIT, preserve_ends: true).first
    else
      value
    end
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
