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

    context "when the Adium adapter is not registered" do
      after do
        described_class.register_adapter(
          :adium,
          described_class::Adapters::Adium
        )
      end

      it "returns a the first registered adapter if Adium is not registered" do
        described_class.instance_variable_get("@adapters").delete(:adium)
        expect(described_class.new).to be_a(described_class::Adapters::Test)
      end
    end
  end
end
