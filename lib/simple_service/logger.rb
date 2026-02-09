# frozen_string_literal: true

module SimpleService
  # Extracted logging behavior so services can include or override it easily.
  module Logger
    def self.included(base)
      base.extend(ClassMethods)
    end

    # rubocop:disable Style/Documentation
    module ClassMethods
      def logger
        return @logger if defined?(@logger) && @logger
        return superclass.logger if superclass.respond_to?(:logger)

        nil
      end

      def logger=(value)
        @logger = value
      end
    end
    # rubocop:enable Style/Documentation

    # Returns the logger to use: instance-level override -> class-level -> Rails.logger -> STDOUT Logger
    def logger
      # try instance-level value
      value = resolve_logger_value(defined?(@logger) && @logger)
      return value if value

      # try class-level value
      value = resolve_logger_value(self.class.logger)
      return value if value

      # rails fallback then stdout
      rails_logger || detected_stdout_logger
    end

    private

    def resolve_logger_value(value)
      return nil unless value

      case value
      when :rails
        rails_logger
      when :stdout
        detected_stdout_logger
      else
        value
      end
    end

    def rails_logger
      return Rails.logger if defined?(Rails) && Rails.respond_to?(:logger) && Rails.logger

      nil
    end

    def detected_stdout_logger
      require "logger"
      @detected_stdout_logger ||= ::Logger.new($stdout)
    end

    # Generic logging helper
    def log(message)
      prefix = "[#{self.class.name}]"

      if logger.respond_to?(:info)
        logger.info("#{prefix} #{message}")
      else
        puts("#{prefix} #{message}")
      end
    end
  end
end
