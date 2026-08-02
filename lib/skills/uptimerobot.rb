# frozen_string_literal: true

# Reads UptimeRobot monitor records for a configured API key.
module Skills
  # Reads UptimeRobot monitor records for a configured API key.
  class UptimeRobot
    MONITORS_URL = 'https://api.uptimerobot.com/v2/getMonitors'

    def self.from_environment
      api_key = ENV.fetch('UPTIMEROBOT_API_KEY', '').strip
      return nil if api_key.empty?

      monitor_ids = ENV.fetch('UPTIMEROBOT_MONITOR_IDS', '').split(',').map(&:strip).reject(&:empty?)
      new(api_key, monitor_ids:)
    end

    def initialize(api_key, monitor_ids: [], http_client: HTTPClient.new)
      @api_key = api_key
      @monitor_ids = monitor_ids
      @http_client = http_client
    end

    def monitor(name, params: {})
      requested_params = params
      requested_params = params.merge('monitors' => @monitor_ids.join('-')) unless @monitor_ids.empty?
      data = monitor_data(requested_params)
      found = find_monitor(data, name)
      return { data:, monitor: found } if found || @monitor_ids.empty?

      data = monitor_data(params)
      { data:, monitor: find_monitor(data, name) }
    end

    private

    def monitor_data(params)
      data = @http_client.post_form_json(MONITORS_URL, { 'api_key' => @api_key, 'format' => 'json' }.merge(params))
      error = data['error']
      raise "UptimeRobot #{error['type']}: #{error['message']}" if data['stat'] == 'fail' && error

      data
    end

    def find_monitor(data, name)
      data.fetch('monitors', []).find do |monitor|
        [monitor['friendly_name'], monitor['url']].compact.any? { |value| value.include?(name) }
      end
    end
  end
end
