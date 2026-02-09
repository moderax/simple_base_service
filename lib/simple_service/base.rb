# frozen_string_literal: true

module SimpleService
  # Base class for all application services providing a standard interface for running service methods
  class Base
    attr_reader :errors, :args

    # Main entry point to execute a method from the class level
    def self.run(method_name = :call, **args, &)
      instance = new(**args, &)

      # Passing 'true' as the second argument allows respond_to? to check for private methods as well
      unless instance.respond_to?(method_name, true)
        raise NoMethodError, "Method :#{method_name} is not implemented or not found in #{name}"
      end

      instance.send(method_name)
    end

    # Initialize the service with flexible arguments and auto-set instance variables
    def initialize(**args)
      @errors = []
      @args = args

      # Automatically set instance variables for each key in args
      args.each do |key, value|
        instance_variable_set("@#{key}", value) if key.to_s.match?(/\A[a-z_][a-z0-9_]*\z/i)
      end
    end

    # Default method to be overridden by subclasses
    def call
      raise NotImplementedError, "#{self.class.name} must implement the #call method"
    end

    private

    include SimpleService::Logger

    private :logger, :log

    # Check if there are any accumulated errors
    def success?
      @errors.empty?
    end

    # Check if any errors have occurred
    def failure?
      !success?
    end

    # Helper to add error messages to the collection uniquely
    def add_error(message)
      return if message.nil?

      @errors << message unless @errors.include?(message)
    end
  end
end
