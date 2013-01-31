require "spec_helper"

describe TamTam::Adapters::Messages do
  let(:fixtures) { fixtures_for(["messages", "chat.db"]) }

  subject { described_class.new(fixtures) }

  describe "#load_messages" do
    it "returns an array of message hashes" do
      messages = subject.load_messages([1, 2, 3])
      expect(messages).to respond_to(:each)
      expect(messages.first.keys).to match_array([:sender, :text, :time])
    end
  end
end
