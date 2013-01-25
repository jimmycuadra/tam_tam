require "spec_helper"

describe TamTam do
  describe ".new" do
    it "returns a new TamTam::Logs object" do
      expect(described_class.new).to be_a(described_class::Logs)
    end
  end
end
