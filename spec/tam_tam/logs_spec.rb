require "spec_helper"

describe TamTam::Logs do
  def adium_fixtures
    File.expand_path(File.join("..", "..", "fixtures", "adium"), __FILE__)
  end

  subject do
    TamTam.new(path: adium_fixtures)
  end

  describe "#messages" do
    it "returns the messages for the given logs" do
      expect(subject.messages).to be_a(TamTam::Messages)
    end
  end

  describe "#to_a" do
    it "returns an array of log files" do
      expect(subject.to_a).to eq(Dir["#{adium_fixtures}/**/*.xml"])
    end

    it "raises an exception if #to_a is not implemented by the subclass" do
      expect {
        described_class.new.to_a
      }.to raise_error(TamTam::AbstractMethodError)
    end
  end
end
