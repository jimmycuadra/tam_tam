require "spec_helper"

describe TamTam do
  describe ".new" do
    it "returns a new Adium adapter" do
      expect(described_class.new).to be_a(described_class::Adapters::Adium)
    end

    it "returns a new adapter as specified" do
      adapter = described_class.new(adapter: :test)
      expect(adapter).to be_a(described_class::Adapters::Test)
    end

    it "returns a the first registered adapter if Adium is not registered" do
      begin
        described_class.unregister_adapter(:adium)
        expect(described_class.new).to be_a(described_class::Adapters::Test)
      ensure
        described_class.register_adapter(:adium, TamTam::Adapters::Adium)
      end
    end
  end
end
