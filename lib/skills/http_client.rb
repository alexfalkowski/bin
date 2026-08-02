# frozen_string_literal: true

# Provides resilient read-only JSON requests for provider sources.
module Skills
  # Provides resilient read-only JSON requests for provider sources.
  class HTTPClient
    TIMEOUT_SECONDS = 15
    RETRY_MAX_ATTEMPTS = 3
    RETRY_BASE_DELAY_SECONDS = 0.2
    RETRY_MAX_DELAY_SECONDS = 5
    RETRYABLE_STATUS_CODES = [429, 502, 503, 504].freeze
    TRANSIENT_ERRORS = [
      OpenSSL::SSL::SSLError, EOFError, Errno::ECONNRESET, Errno::EPIPE, Errno::ECONNREFUSED, Errno::ETIMEDOUT,
      Errno::EHOSTUNREACH, Errno::ENETUNREACH, Net::OpenTimeout, Net::ReadTimeout
    ].freeze

    def get_json(url, headers: {})
      uri = URI(url)
      request = Net::HTTP::Get.new(uri)
      headers.each { |key, value| request[key] = value }
      json_response(uri, request)
    end

    def get_text(url, headers: {})
      uri = URI(url)
      request = Net::HTTP::Get.new(uri)
      headers.each { |key, value| request[key] = value }
      text_response(uri, request)
    end

    def post_form_json(url, params)
      uri = URI(url)
      request = Net::HTTP::Post.new(uri)
      request.set_form_data(params)
      json_response(uri, request)
    end

    private

    def json_response(uri, request)
      response = response(uri, request)
      raise "#{uri} #{response.code}: #{response.body}" unless response.is_a?(Net::HTTPSuccess)

      JSON.parse(response.body)
    end

    def text_response(uri, request)
      response = response(uri, request)
      raise "HTTP #{response.code}" unless response.is_a?(Net::HTTPSuccess)

      response.body.force_encoding(Encoding::UTF_8)
    end

    def response(uri, request)
      attempt = 0
      loop do
        attempt += 1
        response = perform_request(uri, request)
        return response unless retryable_response?(response) && attempt < RETRY_MAX_ATTEMPTS

        sleep(retry_delay(response, attempt))
      rescue *TRANSIENT_ERRORS
        raise if attempt >= RETRY_MAX_ATTEMPTS

        sleep(exponential_retry_delay(attempt))
      end
    end

    def perform_request(uri, request)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.open_timeout = TIMEOUT_SECONDS
      http.read_timeout = TIMEOUT_SECONDS
      http.request(request)
    end

    def retryable_response?(response)
      RETRYABLE_STATUS_CODES.include?(response.code.to_i)
    end

    def retry_delay(response, attempt)
      retry_after_delay(response) || exponential_retry_delay(attempt)
    end

    def retry_after_delay(response)
      value = response['Retry-After']
      return nil if value.nil? || value.empty?

      delay = value.match?(/\A\d+(?:\.\d+)?\z/) ? value.to_f : [Time.httpdate(value) - Time.now, 0].max
      [delay, RETRY_MAX_DELAY_SECONDS].min
    rescue ArgumentError
      nil
    end

    def exponential_retry_delay(attempt)
      delay = [RETRY_BASE_DELAY_SECONDS * (2**(attempt - 1)), RETRY_MAX_DELAY_SECONDS].min
      delay * (0.5 + rand)
    end
  end
end
