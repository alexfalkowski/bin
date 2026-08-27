# frozen_string_literal: true

# Reads CircleCI API v1.1 and v2 records for a configured token.
module Skills
  # Reads CircleCI API v1.1 and v2 records for a configured token.
  class CircleCI
    API_V2_URL = 'https://circleci.com/api/v2'
    API_V1_URL = 'https://circleci.com/api/v1.1'
    PAGE_LIMIT = 10
    PROJECT_PIPELINE_PAGE_LIMIT = 50
    TEST_RESULT_PAGE_LIMIT = 5

    def self.token
      token = ENV['CIRCLE_TOKEN'] || ENV['CIRCLECI_TOKEN'] || ENV.fetch('CIRCLECI_CLI_TOKEN', nil)
      return token unless token.nil? || token.empty?

      path = ENV['CIRCLECI_CLI_CONFIG'] || File.join(Dir.home, '.circleci', 'cli.yml')
      return nil unless File.exist?(path)

      YAML.safe_load_file(path).fetch('token')
    end

    def initialize(token, http_client: HTTPClient.new)
      @token = token
      @http_client = http_client
    end

    def project_pipelines(owner_repo, branch: nil, page_token: nil)
      query = {}
      query['branch'] = branch if branch
      query['page-token'] = page_token if page_token
      get("/project/gh/#{owner_repo}/pipeline", query:)
    end

    def pipeline(id)
      get("/pipeline/#{id}")
    end

    def workflows(pipeline_id, page_token: nil)
      get("/pipeline/#{pipeline_id}/workflow", query: { 'page-token' => page_token }.compact)
    end

    def workflow_jobs(workflow_id, page_token: nil)
      get("/workflow/#{workflow_id}/job", query: { 'page-token' => page_token }.compact)
    end

    def job_details(owner_repo, job_number)
      get("/project/gh/#{owner_repo}/job/#{job_number}")
    end

    def test_results(owner_repo, job_number, page_token: nil)
      get("/project/gh/#{owner_repo}/#{job_number}/tests", query: { 'page-token' => page_token }.compact)
    end

    def flaky_tests(owner_repo)
      get("/insights/gh/#{owner_repo}/flaky-tests")
    end

    def project_pipelines_since(owner_repo, branch, since:)
      pipelines = []
      page_token = nil
      PAGE_LIMIT.times do
        data = project_pipelines(owner_repo, branch:, page_token:)
        items = data.fetch('items', [])
        pipelines.concat(items.select { |pipeline| Time.parse(pipeline.fetch('created_at')) >= since })
        oldest = items.filter_map { |pipeline| Time.parse(pipeline.fetch('created_at')) }.min
        page_token = data['next_page_token']
        return pipelines if items.empty? || page_token.nil? || (oldest && oldest < since)
      end
      raise Skills::Collection::Limit, 'CircleCI pipeline pagination reached its configured limit'
    end

    def latest_pipeline(owner_repo, branch)
      project_pipelines(owner_repo, branch:).fetch('items', []).first
    end

    def pipeline_by_number(owner_repo, number)
      project_pipeline_pages_complete?(owner_repo) do |items|
        found = items.find { |pipeline| pipeline['number'].to_i == number }
        return found if found
      end
      nil
    end

    def pipelines_for_revision(owner_repo, revision, limit:)
      matches = []
      observed_matching_pipeline_count = 0
      complete = project_pipeline_pages_complete?(owner_repo) do |items|
        page_matches = items.select { |pipeline| pipeline.dig('vcs', 'revision') == revision }
        observed_matching_pipeline_count += page_matches.length
        matches.concat(page_matches)
        next unless matches.length > limit

        return {
          pipelines: matches.first(limit),
          observed_matching_pipeline_count: observed_matching_pipeline_count,
          candidate_scan_truncated: true
        }
      end

      {
        pipelines: matches,
        observed_matching_pipeline_count: observed_matching_pipeline_count,
        candidate_scan_truncated: !complete
      }
    end

    def latest_pipelines_for_revision(owner_repo, revision, limit:)
      page_token = nil
      PROJECT_PIPELINE_PAGE_LIMIT.times do
        data = project_pipelines(owner_repo, page_token:)
        items = data.fetch('items', [])
        page_matches = items.select { |pipeline| pipeline.dig('vcs', 'revision') == revision }
        unless page_matches.empty?
          pipelines = page_matches.first(limit)
          return {
            pipelines: pipelines,
            observed_matching_pipeline_count: page_matches.length,
            candidate_scan_truncated: page_matches.length > pipelines.length
          }
        end

        page_token = data['next_page_token']
        return empty_latest_revision_candidates unless page_token
      end

      truncated_latest_revision_candidates
    end

    def pipeline_for_revision(owner_repo, branch, revision)
      page_token = nil
      PAGE_LIMIT.times do
        data = project_pipelines(owner_repo, branch:, page_token:)
        found = data.fetch('items', []).find { |pipeline| pipeline.dig('vcs', 'revision') == revision }
        return found if found

        page_token = data['next_page_token']
        return nil unless page_token
      end
      nil
    end

    def workflows_for(pipelines)
      pipelines.flat_map do |pipeline|
        paginated { |page_token| workflows(pipeline.fetch('id'), page_token:) }.map do |workflow|
          workflow.merge(
            'pipeline_created_at' => pipeline.fetch('created_at'),
            'pipeline_number' => pipeline.fetch('number')
          )
        end
      end
    end

    def workflows_for_pipeline(pipeline_id)
      paginated { |page_token| workflows(pipeline_id, page_token:) }
    end

    def jobs_for(workflows)
      workflows.flat_map do |workflow|
        paginated { |page_token| workflow_jobs(workflow.fetch('id'), page_token:) }.map do |job|
          job.merge('workflow_id' => workflow.fetch('id'), 'workflow_created_at' => workflow.fetch('created_at'))
        end
      end
    end

    def jobs_for_workflows(workflows)
      workflows.flat_map do |workflow|
        paginated { |page_token| workflow_jobs(workflow.fetch('id'), page_token:) }.map do |job|
          job.merge('workflow_id' => workflow.fetch('id'), 'workflow_name' => workflow.fetch('name'))
        end
      end
    end

    def test_results_for(owner_repo, job_number)
      items = []
      page_token = nil
      TEST_RESULT_PAGE_LIMIT.times do
        data = test_results(owner_repo, job_number, page_token:)
        items.concat(data.fetch('items', []))
        page_token = data['next_page_token']
        return { items: items, truncated: false } unless page_token
      end
      { items: items, truncated: true }
    end

    def legacy_job_details(owner_repo, job_number)
      v1_get("/project/github/#{owner_repo}/#{job_number}")
    end

    def failed_steps_for(owner_repo, job_number)
      legacy_job_details(owner_repo, job_number).fetch('steps', []).flat_map do |step|
        step.fetch('actions', []).filter_map do |action|
          next unless failed_job_step?(action)

          step.slice('name').merge(
            action.slice('status', 'exit_code', 'bash_command', 'has_output', 'truncated')
          ).merge('output' => action_output(action), 'source' => 'circleci-v1')
        end
      end
    end

    private

    def get(path, query: {})
      path = "#{path}?#{URI.encode_www_form(query)}" unless query.empty?
      @http_client.get_json("#{API_V2_URL}#{path}", headers: { 'Circle-Token' => @token })
    end

    def v1_get(path)
      @http_client.get_json("#{API_V1_URL}#{path}", headers: { 'Circle-Token' => @token })
    end

    def action_output(action)
      return nil unless action['has_output'] && action['output_url']

      @http_client.get_text(action.fetch('output_url'))
    end

    def failed_job_step?(action)
      !%w[success running on_hold not_run].include?(action['status'])
    end

    def paginated
      items = []
      page_token = nil
      PAGE_LIMIT.times do
        data = yield(page_token)
        items.concat(data.fetch('items', []))
        page_token = data['next_page_token']
        return items unless page_token
      end
      raise Skills::Collection::Limit, 'CircleCI pagination reached its configured limit'
    end

    def project_pipeline_pages_complete?(owner_repo)
      page_token = nil
      PROJECT_PIPELINE_PAGE_LIMIT.times do
        data = project_pipelines(owner_repo, page_token:)
        yield(data.fetch('items', []))
        page_token = data['next_page_token']
        return true unless page_token
      end
      false
    end

    def empty_latest_revision_candidates
      { pipelines: [], observed_matching_pipeline_count: 0, candidate_scan_truncated: false }
    end

    def truncated_latest_revision_candidates
      { pipelines: [], observed_matching_pipeline_count: 0, candidate_scan_truncated: true }
    end
  end
end
