require "spec_helper"

describe TamTam do
  describe ".new" do
    it "returns a new default adapter" do
      expect(described_class.new).to be_a(described_class::Logs::Adium)
    end

    context "with a test adapter" do
      let!(:test_adapter) do
        klass = Class.new(described_class::Logs)

        klass.singleton_class.abstract_methods.each do |method|
          klass.stub(method)
        end

        klass
      end

      after do
        described_class::Logs.adapters.delete(:test)
      end

      it "returns a new adapter as specified" do
        expect(described_class.new(adapter: :test)).to be_a(test_adapter)
      end
    end
  end
end
