# frozen_string_literal: true

# Reads local Git repository metadata and history.
module Skills
  # Reads local Git repository metadata and history.
  class Git
    def initialize(repo_path, command: Command.new)
      @repo_path = repo_path
      @command = command
    end

    def root
      capture('rev-parse', '--show-toplevel').strip
    end

    def origin_url
      capture('remote', 'get-url', 'origin').strip
    end

    def current_branch
      capture('branch', '--show-current').strip
    end

    def remote_default_branch
      capture('symbolic-ref', '--quiet', '--short', 'refs/remotes/origin/HEAD', allow_failure: true)
        .strip
        .sub(%r{\Aorigin/}, '')
    end

    def commits_between(start_time, end_time)
      lines(
        'log', "--since=#{start_time.iso8601}", "--until=#{end_time.iso8601}",
        '--no-merges', '--format=%H%x09%aI%x09%an%x09%s'
      ).map do |line|
        sha, authored_at, author, subject = line.split("\t", 4)
        { sha:, authored_at:, author:, subject: }
      end
    end

    def tags_between(start_time, end_time)
      tags.select do |tag|
        created_at = Time.parse(tag.fetch(:created_at))
        created_at >= start_time && created_at < end_time
      end
    end

    def latest_tag
      tags(sort: '-creatordate', count: 1).first
    end

    def commit_count(revision_range = 'HEAD')
      capture('rev-list', '--count', revision_range).to_i
    end

    def tag_revision(tag)
      value = capture('rev-list', '-n', '1', tag, allow_failure: true).strip
      value.empty? ? nil : value
    end

    def tree(revision)
      value = capture('rev-parse', '--verify', '--end-of-options', "#{revision}^{tree}", allow_failure: true).strip
      value.empty? ? nil : value
    end

    def resolve_commit(revision)
      value = capture('rev-parse', '--verify', '--end-of-options', "#{revision}^{commit}", allow_failure: true).strip
      value.empty? ? nil : value
    end

    private

    def tags(sort: 'creatordate', count: nil)
      args = ['for-each-ref', 'refs/tags', "--sort=#{sort}"]
      args.push('--count', count.to_s) if count
      args << '--format=%(refname:short)%09%(creatordate:iso-strict)'
      lines(*args).filter_map do |line|
        name, created_at = line.split("\t", 2)
        { tag: name, created_at: created_at } if name && created_at
      end
    end

    def capture(...)
      @command.capture('git', '-C', @repo_path, ...)
    end

    def lines(...)
      capture(...).lines.map(&:chomp).reject(&:empty?)
    end
  end
end
