# frozen_string_literal: true

# Provides the read-only command boundary used by local and CLI-backed sources.
module Skills
  # Provides the read-only command boundary used by local and CLI-backed sources.
  class Command
    def available?(name)
      ENV.fetch('PATH', '').split(File::PATH_SEPARATOR).any? do |directory|
        path = File.join(directory, name)
        File.executable?(path) && !File.directory?(path)
      end
    end

    def capture(*args, allow_failure: false)
      output, error, status = Open3.capture3(*args)
      raise "#{args.join(' ')} failed: #{error.strip}" if !allow_failure && !status.success?

      output
    end
  end
end
