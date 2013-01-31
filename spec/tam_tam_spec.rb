require "spec_helper"

describe TamTam do
  describe ".new" do
    it "returns a new adapter as specified" do
      logs = described_class.new(adapter: :test)
      expect(logs.adapter).to be_a(described_class::Adapters::Test)
    end

    it "returns a new Adium adapter by default" do
      expect(described_class.new.adapter).to be_a(
        described_class::Adapters::Adium
      )
    end

    it "returns the first registered adapter if Adium is not registered" do
      begin
        described_class.unregister_adapter(:adium)
        expect(described_class.new.adapter).to be_a(
          described_class::Adapters::Messages
        )
      ensure
        described_class.register_adapter(:adium, TamTam::Adapters::Adium)
      end
    end
  end
end
