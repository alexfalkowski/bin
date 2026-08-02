# frozen_string_literal: true

# Builds the stable source status values emitted by the skill collectors.
module Skills
  # Builds the stable source status values emitted by the skill collectors.
  module SourceStatus
    module_function

    def skipped(reason)
      { status: 'skipped', reason: reason }
    end

    def unavailable(reason)
      { status: 'unavailable', reason: reason }
    end

    def unavailable?(value)
      value.is_a?(Hash) && %w[skipped unavailable].include?(value[:status])
    end

    def error_reason(error)
      return error.message if error.is_a?(Collection::Timeout) || error.is_a?(Collection::Limit)
      if error.is_a?(Timeout::Error)
        return "source collection timed out after #{Collection::SOURCE_TIMEOUT_SECONDS} seconds"
      end

      "source collection failed (#{error.class})"
    end

    def unavailable_for(error)
      unavailable(error_reason(error))
    end
  end
end
