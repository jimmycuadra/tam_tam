require "spec_helper"

describe TamTam::Adapters::Adium do
  let(:fixtures) { fixtures_for("adium") }

  subject { described_class.new(fixtures) }

  describe "#load_messages" do
    it "returns an array of message hashes" do
      matches = Dir["#{fixtures}/GTalk*/**/*.xml"]
      messages = subject.load_messages(matches)
      expect(messages).to respond_to(:each)
      expect(messages.first.keys).to match_array([:sender, :text, :time])
    end
  end

  describe "#as" do
    it "filters the logs by a single account" do
      expect(subject.as(["bongo"])).to match_array(
        Dir["#{fixtures}/AIM.bongo/**/*.xml"]
      )
    end

    it "filters the logs by multiple accounts" do
      expect(subject.as(["bongo", "bongo@gmail.com"])).to match_array(
        Dir["#{fixtures}/**/*.xml"]
      )
    end
  end

  describe "#with" do
    it "filters the logs by a single participant" do
      expect(subject.with(["bongita"])).to match_array(
        Dir["#{fixtures}/AIM.bongo/**/*.xml"]
      )
    end

    it "filters the logs by multiple participants" do
      expect(subject.with(["bongita", "rumples@gmail.com"])).to match_array(
        Dir["#{fixtures}/**/*.xml"]
      )
    end
  end

  describe "#on" do
    it "filters the logs by date" do
      expect(subject.on(Time.new(2011, 7, 23))).to match_array(
        Dir["#{fixtures}/AIM.bongo/bongita/*07-23*/*.xml"]
      )
    end
  end

  describe "#between" do
    it "filters the logs by a date range" do
      start = Time.new(2011, 7, 23)
      stop = Time.new(2011, 7, 24)

      expect(subject.between(start, stop)).to match_array(
        Dir["#{fixtures}/AIM.bongo/**/*.xml"]
      )
    end
  end
end
