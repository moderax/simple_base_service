# frozen_string_literal: true

class TestLogger
  attr_reader :messages

  def initialize
    @messages = []
  end

  def info(msg)
    @messages << msg
  end
end

class LogService < SimpleService::Base
  def call
    log("hello")
  end
end

RSpec.describe SimpleService::Base do
  after do
    described_class.logger = nil
  end

  describe "object-based loggers" do
    it "uses provided instance logger" do
      logger = TestLogger.new

      LogService.run(logger: logger)

      expect(logger.messages).to include("[LogService] hello")
    end

    it "uses class-level default logger when instance logger not provided" do
      logger = TestLogger.new
      described_class.logger = logger

      LogService.run

      expect(logger.messages).to include("[LogService] hello")
    end
  end

  describe "symbol-based loggers" do
    it "uses Rails logger when passing :rails" do
      test_logger = TestLogger.new

      stub_const("Rails", Module.new)
      allow(Rails).to receive(:logger).and_return(test_logger)

      LogService.run(logger: :rails)

      expect(test_logger.messages).to include("[LogService] hello")
    end

    it "uses STDOUT logger when passing :stdout" do
      expect { LogService.run(logger: :stdout) }
        .to output(/\[LogService\] hello/).to_stdout
    end
  end
end
