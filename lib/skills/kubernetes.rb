# frozen_string_literal: true

# Reads Kubernetes resources through kubectl from the active context.
module Skills
  # Reads Kubernetes resources through kubectl from the active context.
  class Kubernetes
    def initialize(command: Command.new)
      @command = command
    end

    def available?
      @command.available?('kubectl')
    end

    def current_context
      @command.capture('kubectl', 'config', 'current-context', allow_failure: true).strip
    end

    def deployments
      json('get', 'deployments', '-A', '-o', 'json').fetch('items', [])
    end

    def pods(namespace:, selector:)
      json('get', 'pods', '-n', namespace, '-l', selector, '-o', 'json').fetch('items', [])
    end

    def workload(name)
      matching_deployments = deployments.select do |deployment|
        deployment.dig('metadata', 'name')&.include?(name) || deployment.dig('metadata', 'namespace')&.include?(name)
      end
      {
        context: current_context,
        deployments: matching_deployments.map { |deployment| deployment_summary(deployment) },
        pods: matching_deployments.flat_map { |deployment| deployment_pods(deployment) }.map { |pod| pod_summary(pod) }
      }
    end

    private

    def deployment_pods(deployment)
      namespace = deployment.dig('metadata', 'namespace')
      labels = deployment.dig('spec', 'selector', 'matchLabels') || {}
      selector = labels.map { |key, value| "#{key}=#{value}" }.join(',')
      return [] if selector.empty?

      pods(namespace:, selector:)
    end

    def deployment_summary(deployment)
      status = deployment.fetch('status', {})
      spec = deployment.fetch('spec', {})
      container = deployment.dig('spec', 'template', 'spec', 'containers', 0) || {}
      {
        namespace: deployment.dig('metadata', 'namespace'),
        name: deployment.dig('metadata', 'name'),
        desired_replicas: spec['replicas'],
        ready_replicas: status['readyReplicas'] || 0,
        available_replicas: status['availableReplicas'] || 0,
        updated_replicas: status['updatedReplicas'] || 0,
        image: container['image']
      }
    end

    def pod_summary(pod)
      statuses = pod.dig('status', 'containerStatuses') || []
      conditions = pod.dig('status', 'conditions') || []
      ready_condition = conditions.find { |condition| condition['type'] == 'Ready' }
      {
        namespace: pod.dig('metadata', 'namespace'),
        name: pod.dig('metadata', 'name'),
        phase: pod.dig('status', 'phase'),
        ready: ready_condition ? ready_condition['status'] == 'True' : false,
        restarts: statuses.sum { |status| status['restartCount'].to_i },
        started_at: pod.dig('status', 'startTime')
      }
    end

    def json(...)
      JSON.parse(@command.capture('kubectl', ...))
    end
  end
end
