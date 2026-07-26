# frozen_string_literal: true

# Provides read-only access to the external sources used by collector scripts.
# rubocop:disable Metrics/ModuleLength
module EvidenceSources
  MAX_CONCURRENT_SOURCES = 4
  SOURCE_TIMEOUT_SECONDS = 30
  CIRCLECI_SOURCE_TIMEOUT_SECONDS = 180
  GITHUB_SOURCE_TIMEOUT_SECONDS = 180
  HTTP_TIMEOUT_SECONDS = 15
  HTTP_RETRY_MAX_ATTEMPTS = 3
  HTTP_RETRY_BASE_DELAY_SECONDS = 0.2
  HTTP_RETRY_MAX_DELAY_SECONDS = 5
  RETRYABLE_HTTP_STATUS_CODES = [429, 502, 503, 504].freeze
  TRANSIENT_HTTP_ERRORS = [
    OpenSSL::SSL::SSLError, EOFError, Errno::ECONNRESET, Errno::EPIPE, Errno::ECONNREFUSED, Errno::ETIMEDOUT,
    Errno::EHOSTUNREACH, Errno::ENETUNREACH, Net::OpenTimeout, Net::ReadTimeout
  ].freeze

  # Marks a collector deadline with a fixed, safe message for report output.
  class SourceTimeout < Timeout::Error
  end

  # Marks an intentional, safe collection limit for report output.
  class SourceLimit < StandardError
  end

  private

  # Runs independent source collectors with bounded concurrency while preserving result order.
  def collect_sources(sources, overall_timeout_seconds: nil, on_start: nil, on_finish: nil)
    collection = { started_at: monotonic_time, results: {}, lock: Mutex.new, cancelled: false }
    queue = source_queue(sources)
    workers = source_workers(sources, queue, collection, on_start, on_finish)

    wait_for_sources(workers, overall_timeout_seconds)
    if workers.any?(&:alive?)
      mark_overall_timeout_sources(sources, collection, on_finish, overall_timeout_seconds)
    else
      workers.each(&:join)
    end
    sources.to_h { |name, _| [name, collection.fetch(:results).fetch(name)] }
  end

  def source_queue(sources)
    Queue.new.tap { |queue| sources.each { |source| queue << source } }
  end

  def source_workers(sources, queue, collection, on_start, on_finish)
    Array.new([sources.length, MAX_CONCURRENT_SOURCES].min) do
      Thread.new { collect_queued_sources(queue, collection, on_start, on_finish) }
    end
  end

  def collect_queued_sources(queue, collection, on_start, on_finish)
    loop do
      break if collection_cancelled?(collection)

      source = queue.pop(true)
      collect_queued_source(source, collection, on_start, on_finish)
    rescue ThreadError
      break
    end
  end

  def collect_queued_source(source, collection, on_start, on_finish)
    name, collect = source
    source_started_at = monotonic_time
    on_start&.call(name)
    result = collect_source(name, collect)
    return if collection_cancelled?(collection)

    collection.fetch(:lock).synchronize { collection.fetch(:results)[name] = result }
    on_finish&.call(name, result, monotonic_time - source_started_at)
  end

  def wait_for_sources(workers, overall_timeout_seconds)
    return workers.each(&:join) unless overall_timeout_seconds

    deadline = monotonic_time + overall_timeout_seconds
    workers.each do |worker|
      remaining_seconds = deadline - monotonic_time
      break unless remaining_seconds.positive?

      worker.join(remaining_seconds)
    end
  end

  def mark_overall_timeout_sources(sources, collection, on_finish, overall_timeout_seconds)
    collection.fetch(:lock).synchronize { collection[:cancelled] = true }
    missing_source_names(sources, collection).each do |name|
      mark_overall_timeout_source(name, collection, on_finish, overall_timeout_seconds)
    end
  end

  def missing_source_names(sources, collection)
    sources.map(&:first).reject { |name| collection_result(collection, name) }
  end

  def mark_overall_timeout_source(name, collection, on_finish, overall_timeout_seconds)
    result = unavailable("overall collection timed out after #{overall_timeout_seconds} seconds")
    store_collection_result(collection, name, result)
    on_finish&.call(name, result, monotonic_time - collection.fetch(:started_at))
  end

  def collection_result(collection, name)
    collection.fetch(:lock).synchronize { collection.fetch(:results)[name] }
  end

  def store_collection_result(collection, name, result)
    collection.fetch(:lock).synchronize { collection.fetch(:results)[name] = result }
  end

  def monotonic_time
    Process.clock_gettime(Process::CLOCK_MONOTONIC)
  end

  def collection_cancelled?(collection)
    collection.fetch(:lock).synchronize { collection[:cancelled] }
  end

  def collect_source(name, collect)
    timeout_seconds = source_timeout_seconds(name)
    Timeout.timeout(timeout_seconds, SourceTimeout, timeout_reason(timeout_seconds)) { collect.call }
  rescue StandardError => e
    unavailable_for_error(e)
  end

  def source_timeout_seconds(name = nil)
    return CIRCLECI_SOURCE_TIMEOUT_SECONDS if name == :circleci
    return GITHUB_SOURCE_TIMEOUT_SECONDS if name == :github

    SOURCE_TIMEOUT_SECONDS
  end

  def unavailable_for_error(error)
    unavailable(source_error_reason(error))
  end

  def source_error_reason(error)
    return error.message if error.is_a?(SourceTimeout) || error.is_a?(SourceLimit)
    return timeout_reason(source_timeout_seconds) if error.is_a?(Timeout::Error)

    "source collection failed (#{error.class})"
  end

  def timeout_reason(seconds)
    "source collection timed out after #{seconds} seconds"
  end

  def circleci_get(path, token)
    http_json("https://circleci.com/api/v2#{path}", 'Circle-Token' => token)
  end

  def uptimerobot(params)
    uri = URI('https://api.uptimerobot.com/v2/getMonitors')
    request = Net::HTTP::Post.new(uri)
    request.set_form_data(params)
    # getMonitors is a read-only query even though UptimeRobot uses POST.
    response = http_response(uri, request, retryable: true)
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
    response = http_response(uri, request, retryable: true)
    raise "#{url} #{response.code}: #{response.body}" unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)
  end

  def http_response(uri, request, retryable: false)
    attempt = 0
    loop do
      attempt += 1
      response = perform_http_request(uri, request)
      return response unless retryable && retryable_http_response?(response) && attempt < HTTP_RETRY_MAX_ATTEMPTS

      sleep(retry_delay(response, attempt))
    rescue *TRANSIENT_HTTP_ERRORS
      raise if attempt >= HTTP_RETRY_MAX_ATTEMPTS

      sleep(exponential_retry_delay(attempt))
    end
  end

  def perform_http_request(uri, request)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = HTTP_TIMEOUT_SECONDS
    http.read_timeout = HTTP_TIMEOUT_SECONDS
    http.request(request)
  end

  def retryable_http_response?(response)
    RETRYABLE_HTTP_STATUS_CODES.include?(response.code.to_i)
  end

  def retry_delay(response, attempt)
    retry_after_delay(response) || exponential_retry_delay(attempt)
  end

  def retry_after_delay(response)
    value = response['Retry-After']
    return nil if value.nil? || value.empty?

    delay = if value.match?(/\A\d+(?:\.\d+)?\z/)
              value.to_f
            else
              [Time.httpdate(value) - Time.now, 0].max
            end
    [delay, HTTP_RETRY_MAX_DELAY_SECONDS].min
  rescue ArgumentError
    nil
  end

  def exponential_retry_delay(attempt)
    delay = [HTTP_RETRY_BASE_DELAY_SECONDS * (2**(attempt - 1)), HTTP_RETRY_MAX_DELAY_SECONDS].min
    delay * (0.5 + rand)
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

  def skipped(reason)
    { status: 'skipped', reason: reason }
  end

  def unavailable(reason)
    { status: 'unavailable', reason: reason }
  end
end
# rubocop:enable Metrics/ModuleLength
