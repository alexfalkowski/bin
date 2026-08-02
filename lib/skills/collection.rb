# frozen_string_literal: true

# Runs independently collected source data with bounded concurrency.
module Skills
  # Runs independently collected source data with bounded concurrency.
  class Collection
    MAX_CONCURRENT_SOURCES = 4
    SOURCE_TIMEOUT_SECONDS = 30
    CIRCLECI_SOURCE_TIMEOUT_SECONDS = 180
    GITHUB_SOURCE_TIMEOUT_SECONDS = 180

    class Timeout < Timeout::Error
    end

    class Limit < StandardError
    end

    def self.call(sources, overall_timeout_seconds: nil, on_start: nil, on_finish: nil, &unavailable)
      new(sources, on_start:, on_finish:, unavailable:).call(overall_timeout_seconds:)
    end

    def self.timeout_seconds(name)
      return CIRCLECI_SOURCE_TIMEOUT_SECONDS if name == :circleci
      return GITHUB_SOURCE_TIMEOUT_SECONDS if name == :github

      SOURCE_TIMEOUT_SECONDS
    end

    def initialize(sources, on_start:, on_finish:, unavailable:)
      @sources = sources
      @on_start = on_start
      @on_finish = on_finish
      @unavailable = unavailable
      @collection = { started_at: monotonic_time, results: {}, lock: Mutex.new, cancelled: false }
    end

    def call(overall_timeout_seconds:)
      workers = source_workers
      wait_for_sources(workers, overall_timeout_seconds)
      workers.any?(&:alive?) ? mark_overall_timeout_sources(overall_timeout_seconds) : workers.each(&:join)
      @sources.to_h { |name, _| [name, @collection.fetch(:results).fetch(name)] }
    end

    private

    def source_workers
      queue = Queue.new.tap { |items| @sources.each { |source| items << source } }
      Array.new([@sources.length, MAX_CONCURRENT_SOURCES].min) { Thread.new { collect_queued_sources(queue) } }
    end

    def collect_queued_sources(queue)
      loop do
        break if cancelled?

        source = queue.pop(true)
        collect_source(*source)
      rescue ThreadError
        break
      end
    end

    def collect_source(name, collect)
      started_at = monotonic_time
      @on_start&.call(name)
      result = source_result(name, collect)
      return if cancelled?

      finish_source(name, result, started_at)
    rescue StandardError => e
      return if cancelled?

      finish_source(name, @unavailable.call(e), started_at)
    end

    def source_result(name, collect)
      seconds = self.class.timeout_seconds(name)
      ::Timeout.timeout(seconds, Timeout, timeout_reason(seconds)) { collect.call }
    end

    def finish_source(name, result, started_at)
      store(name, result)
      @on_finish&.call(name, result, monotonic_time - started_at)
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

    def mark_overall_timeout_sources(overall_timeout_seconds)
      @collection.fetch(:lock).synchronize { @collection[:cancelled] = true }
      missing_source_names.each do |name|
        result = @unavailable.call(Timeout.new("overall collection timed out after #{overall_timeout_seconds} seconds"))
        store(name, result)
        @on_finish&.call(name, result, monotonic_time - @collection.fetch(:started_at))
      end
    end

    def missing_source_names
      @sources.map(&:first).reject { |name| result_for(name) }
    end

    def result_for(name)
      @collection.fetch(:lock).synchronize { @collection.fetch(:results)[name] }
    end

    def store(name, result)
      @collection.fetch(:lock).synchronize { @collection.fetch(:results)[name] = result }
    end

    def cancelled?
      @collection.fetch(:lock).synchronize { @collection.fetch(:cancelled) }
    end

    def timeout_reason(seconds)
      "source collection timed out after #{seconds} seconds"
    end

    def monotonic_time
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end
  end
end
