# frozen_string_literal: true

RSpec.describe SimpleService do
  it "has a version number" do
    expect(SimpleService::VERSION).not_to be_nil
  end
end
