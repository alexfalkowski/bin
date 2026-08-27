#!/usr/bin/env ruby
# frozen_string_literal: true

lib = File.expand_path('../../../lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'skills'

# Collects the CircleCI workflow evidence for one exact local revision.
class GapWorkflowCICollector
  CANDIDATE_LIMIT = 5

  def initialize(options)
    @repo_path = File.expand_path(options.fetch(:repo_path))
    @revision = options.fetch(:revision)
    @git = Skills::Git.new(@repo_path)
    @circleci = {}
  end

  def call
    root = @git.root
    revision = @git.resolve_commit(@revision) || @revision
    owner_repo = Skills::GitHub.repository_from_remote(@git.origin_url)

    JSON.pretty_generate(
      repository: owner_repo,
      repo_path: root,
      revision: revision,
      circleci: collect_circleci(root, owner_repo, revision)
    )
  end

  private

  def collect_circleci(root, owner_repo, revision)
    configuration = circleci_configuration(root)
    return skipped('no .circleci/config.yml') unless configuration

    token = Skills::CircleCI.token
    return unavailable('CircleCI token not found') if token.nil? || token.empty?

    matches = circleci_source(token).latest_pipelines_for_revision(owner_repo, revision, limit: CANDIDATE_LIMIT)
    pipelines = matches.fetch(:pipelines)
    return unavailable("No CircleCI pipeline matched revision #{revision}.") if pipelines.empty?

    used_circleci_evidence(matches, revision, token, configuration)
  rescue StandardError => e
    Skills::SourceStatus.unavailable_for(e)
  end

  def used_circleci_evidence(matches, revision, token, configuration)
    pipelines = matches.fetch(:pipelines)
    selected = select_pipeline(pipelines)
    circleci_metadata(matches, revision).merge(
      configuration: configuration,
      matching_pipelines: pipelines.map { |pipeline| pipeline_summary(pipeline) },
      selected_pipeline: pipeline_summary(selected),
      workflow_attempts: workflow_attempts(circleci_source(token).workflows_for_pipeline(selected.fetch('id')))
    )
  end

  def select_pipeline(pipelines)
    branch = @git.current_branch
    on_branch = pipelines.select { |pipeline| pipeline.dig('vcs', 'branch') == branch }
    candidates = on_branch.empty? ? pipelines : on_branch
    candidates.max_by { |pipeline| pipeline.fetch('number', 0).to_i }
  end

  def circleci_metadata(matches, revision)
    {
      status: 'used',
      provider: 'circleci',
      revision: revision,
      exact_revision_match: true,
      observed_matching_pipeline_count: matches.fetch(:observed_matching_pipeline_count),
      candidate_scan_truncated: matches.fetch(:candidate_scan_truncated)
    }
  end

  def circleci_source(token)
    @circleci[token] ||= Skills::CircleCI.new(token)
  end

  def circleci_configuration(root)
    directory = File.join(root, '.circleci')
    primary = File.join(directory, 'config.yml')
    return unless File.file?(primary)

    {
      primary_config: relative_to_root(primary, root),
      configuration_files: Dir.glob([File.join(directory, '**', '*.yml'), File.join(directory, '**', '*.yaml')])
                              .select { |path| File.file?(path) }.sort.map { |path| relative_to_root(path, root) },
      dynamic_config: File.read(primary).match?(/^\s*setup:\s*true\s*(?:#.*)?$/)
    }
  end

  def relative_to_root(path, root)
    path.delete_prefix("#{root}/")
  end

  def unavailable(reason)
    Skills::SourceStatus.unavailable(reason)
  end

  def skipped(reason)
    Skills::SourceStatus.skipped(reason)
  end

  def pipeline_summary(pipeline)
    vcs = pipeline.fetch('vcs', {})
    {
      id: pipeline['id'],
      number: pipeline['number'],
      branch: vcs['branch'],
      revision: vcs['revision'],
      created_at: pipeline['created_at']
    }
  end

  def workflow_attempts(workflows)
    workflows.group_by { |workflow| workflow['name'] }.map do |name, attempts|
      attempts = attempts.sort_by do |workflow|
        [workflow.fetch('auto_rerun_number', 0).to_i, workflow.fetch('created_at', ''), workflow.fetch('id')]
      end
      {
        name: name,
        attempts: attempts.map { |workflow| workflow_summary(workflow) },
        final_attempt: workflow_summary(attempts.last)
      }
    end
  end

  def workflow_summary(workflow)
    workflow.slice('id', 'name', 'status', 'created_at', 'stopped_at', 'auto_rerun_number', 'max_auto_reruns')
  end
end

options = { repo_path: Dir.pwd }

parser = OptionParser.new do |parser|
  parser.banner = 'Usage: collect-ci.rb --revision SHA [--repo PATH]'
  parser.on('--revision SHA', 'Exact commit revision to match against CircleCI.') { |value| options[:revision] = value }
  parser.on('--repo PATH', 'Repository path. Defaults to the current directory.') do |value|
    options[:repo_path] = value
  end
end

begin
  parser.parse!
  raise OptionParser::MissingArgument, '--revision is required' unless options[:revision]
rescue OptionParser::ParseError => e
  warn "gap-workflow-ci: #{e.message}"
  exit 2
end

puts GapWorkflowCICollector.new(options).call
