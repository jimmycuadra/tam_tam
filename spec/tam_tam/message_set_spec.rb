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

  describe "#containing" do
    it "returns only messages containing the string" do
      messages = described_class.new(messages_data[0])
      expect(subject.containing("hey")).to eq(messages)
    end

    it "returns only messages matching a regexp" do
      messages = described_class.new(messages_data[0, 2])
      expect(subject.containing(/h(?:ey|i)/)).to eq(messages)
    end
  end
end
