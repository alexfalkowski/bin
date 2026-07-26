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

  private

  # Runs independent source collectors with bounded concurrency while preserving result order.
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def collect_sources(sources)
    queue = Queue.new
    sources.each_with_index { |source, index| queue << [index, *source] }

    workers = Array.new([sources.length, MAX_CONCURRENT_SOURCES].min) do
      Thread.new do
        results = []
        loop do
          source = begin
            queue.pop(true)
          rescue ThreadError
            nil
          end
          break unless source

          index, name, collect = source
          results << [index, name, collect_source(name, collect)]
        end
        results
      end
    end

    workers.flat_map(&:value).sort_by(&:first).to_h { |_, name, result| [name, result] }
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

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
    return error.message if error.is_a?(SourceTimeout)
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
