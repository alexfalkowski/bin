# frozen_string_literal: true

# Reads GitHub records through the authenticated GitHub CLI.
module Skills
  # Reads GitHub records through the authenticated GitHub CLI.
  class GitHub
    HEALTH_PULL_REQUEST_LIMIT = 6_400

    def initialize(command: Command.new)
      @command = command
    end

    def available?
      @command.available?('gh')
    end

    def self.repository_from_remote(remote)
      clean = remote.delete_suffix('.git')
      return Regexp.last_match(1) if clean.match(/\Agit@github\.com:(.+)\z/)
      return Regexp.last_match(1) if clean.match(%r{\Assh://git@github\.com/(.+)\z})
      return Regexp.last_match(1) if clean.match(%r{\Ahttps?://github\.com/(.+)\z})

      clean
    end

    def default_branch(owner_repo)
      return nil unless available?

      command_json('repo', 'view', owner_repo, '--json', 'defaultBranchRef').dig('defaultBranchRef', 'name')
    rescue StandardError
      nil
    end

    def current_pull_request(owner_repo, branch)
      pull_requests(
        owner_repo,
        state: 'open',
        fields: 'number,title,headRefName,baseRefName,isDraft,mergeStateStatus,reviewDecision',
        head: branch
      ).first
    end

    def pull_requests_for_revision(owner_repo, revision)
      pull_requests(
        owner_repo,
        state: 'all',
        fields: 'number,title,state,headRefName,baseRefName,isDraft,mergedAt,closedAt,mergeCommit',
        search: revision,
        limit: 100
      )
    end

    def open_pull_requests_before(owner_repo, end_time)
      pull_requests(
        owner_repo,
        state: 'all',
        fields: 'number,title,createdAt,updatedAt,closedAt,url',
        search: "created:<=#{date(end_time)}",
        limit: HEALTH_PULL_REQUEST_LIMIT
      )
    end

    def merged_pull_requests_between(owner_repo, start_time, end_time)
      pull_requests(
        owner_repo,
        state: 'merged',
        fields: 'number,title,createdAt,mergedAt,url,reviews',
        search: "merged:#{date_range(start_time, end_time)}",
        limit: HEALTH_PULL_REQUEST_LIMIT
      )
    end

    def pull_requests_created_between(owner_repo, start_time, end_time)
      pull_requests(
        owner_repo,
        state: 'all',
        fields: 'number,createdAt',
        search: "created:#{date_range(start_time, end_time)}",
        limit: HEALTH_PULL_REQUEST_LIMIT
      )
    end

    def unmerged_pull_requests_closed_between(owner_repo, start_time, end_time)
      range = date_range(start_time, end_time)
      pull_requests(
        owner_repo,
        state: 'closed',
        fields: 'number,closedAt,mergedAt',
        search: "closed:#{range} -merged:#{range}",
        limit: HEALTH_PULL_REQUEST_LIMIT
      )
    end

    def commit_statuses(owner_repo, revision, limit:)
      encoded_revision = URI.encode_www_form_component(revision)
      path = "repos/#{owner_repo}/commits/#{encoded_revision}/status?per_page=#{limit}"
      command_json('api', path).fetch('statuses', [])
    end

    private

    def pull_requests(owner_repo, state:, fields:, **options)
      search = options[:search]
      head = options[:head]
      limit = options[:limit]
      args = ['pr', 'list', '--repo', owner_repo, '--state', state]
      args.push('--search', search) if search
      args.push('--head', head) if head
      args.push('--limit', limit.to_s) if limit
      args.push('--json', fields)
      results = command_json(*args)
      if limit && results.length >= limit
        raise Skills::Collection::Limit, 'GitHub pull request query reached its configured result limit'
      end

      results
    end

    def date_range(start_time, end_time)
      "#{date(start_time)}..#{date(end_time - 1)}"
    end

    def date(time)
      time.getutc.strftime('%Y-%m-%d')
    end

    def command_json(...)
      JSON.parse(@command.capture('gh', ...))
    end
  end
end
