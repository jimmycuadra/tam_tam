require "spec_helper"

describe TamTam::Message do
  let(:data) do
    {
      sender: "bongo",
      text: "sup, brah",
      time: Time.new(2011, 12, 25)
    }
  end

  subject { described_class.new(data) }

  describe "#sender" do
    it "returns the sender of the message" do
      expect(subject.sender).to eq("bongo")
    end
  end

  describe "#text" do
    it "returns the text of the message" do
      expect(subject.text).to eq("sup, brah")
    end
  end

  describe "#time" do
    it "returns the time of the message" do
      expect(subject.time).to eq(Time.new(2011, 12, 25))
    end
  end

  describe "#==" do
    it "compares two messages" do
      expect(subject).to eq(subject.dup)
    end
  end
end
