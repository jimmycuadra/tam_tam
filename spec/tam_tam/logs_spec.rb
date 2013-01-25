require "spec_helper"

describe TamTam::Logs do
  describe "#messages" do
    it "returns the messages for the given logs" do
      expect(subject.messages).to be_a(TamTam::Messages)
    end
  end
end
