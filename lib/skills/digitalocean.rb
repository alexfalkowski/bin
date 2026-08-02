# frozen_string_literal: true

# Reads DigitalOcean Kubernetes cluster records for a configured API token.
module Skills
  # Reads DigitalOcean Kubernetes cluster records for a configured API token.
  class DigitalOcean
    KUBERNETES_CLUSTERS_URL = 'https://api.digitalocean.com/v2/kubernetes/clusters'

    def self.from_environment
      token = ENV.fetch('DIGITALOCEAN_ACCESS_TOKEN', nil)
      new(token) unless token.nil? || token.empty?
    end

    def initialize(token, http_client: HTTPClient.new)
      @token = token
      @http_client = http_client
    end

    def kubernetes_clusters
      @http_client
        .get_json(KUBERNETES_CLUSTERS_URL, headers: { 'Authorization' => "Bearer #{@token}" })
        .fetch('kubernetes_clusters', [])
    end
  end
end
