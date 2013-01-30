require "spec_helper"

describe TamTam::MessageSet do
  let(:messages_data) do
    [
      { sender: "wongo", text: "hey there", time: Time.now - 10000 },
      { sender: "bongo", text: "hi, how was your day?", time: Time.now - 1000 },
      { sender: "wongo", text: "great! yours?", time: Time.now },
    ]
  end

  subject do
    described_class.new(messages_data)
  end

  describe "#to_s" do
    it "shows the object ID as hexadecimal and the message count" do
      expect(subject.to_s).to match(
        %r{#<TamTam::MessageSet:0x[0-9a-f]+ size=3>}
      )
    end
  end

  describe "#including" do
    it "returns only messages including the string" do
      messages = described_class.new([messages_data[0]])
      expect(subject.including("hey")).to eq(messages)
    end
  end

  describe "#matching" do
    it "returns only messages matching a regexp" do
      messages = described_class.new(messages_data[0, 2])
      expect(subject.matching(/h(?:ey|i)/)).to eq(messages)
    end
  end

  describe "#sent_by" do
    it "returns only messages sent by the specified sender" do
      wongos_messages = described_class.new(
        messages_data.reject { |m| m[:sender] != "wongo" }
      )
      expect(subject.sent_by("wongo")).to eq(wongos_messages)
    end
  end

  describe "#by_count" do
    it "returns a hash of message text by number of occurrences" do
      messages_data << messages_data[0]
      expect(subject.by_count).to eq(
        "hey there" => 2,
        "hi, how was your day?" => 1,
        "great! yours?" => 1
      )
    end
  end

  describe "#each" do
    it "yields each message to the block" do
      expect(subject.map(&:sender)).to eql(["wongo", "bongo", "wongo"])
    end
  end
end
