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

  describe "#as" do
    it "filters the logs by a single account" do
      expect(subject.as("bongo").to_a).to eq(
        Dir["#{adium_fixtures}/AIM.bongo/**/*.xml"]
      )
    end

    it "filters the logs by multiple accounts (with multiple arguments)" do
      expect(subject.as("bongo", "bongo@gmail.com").to_a).to eq(
        Dir["#{adium_fixtures}/**/*.xml"]
      )
    end

    it "filters the logs by multiple accounts (with an array)" do
      expect(subject.as(["bongo", "bongo@gmail.com"]).to_a).to eq(
        Dir["#{adium_fixtures}/**/*.xml"]
      )
    end
  end

  describe "#with" do
    it "filters the logs by a single participant" do
      expect(subject.with("bongita").to_a).to eq(
        Dir["#{adium_fixtures}/AIM.bongo/**/*.xml"]
      )
    end

    it "filters the logs by multiple participants (with multiple arguments)" do
      expect(subject.with("bongita", "rumples@gmail.com").to_a).to eq(
        Dir["#{adium_fixtures}/**/*.xml"]
      )
    end

    it "filters the logs by multiple participants (with an array)" do
      expect(subject.with(["bongita", "rumples@gmail.com"]).to_a).to eq(
        Dir["#{adium_fixtures}/**/*.xml"]
      )
    end
  end

  describe "#on" do
    it "filters the logs by date (as a string)" do
      expect(subject.on("July 23, 2011").to_a).to eq(
        Dir["#{adium_fixtures}/AIM.bongo/bongita/*07-23*/*.xml"]
      )
    end

    it "filters the logs by date (as a Time object)" do
      expect(subject.on(Time.new(2011, 7, 23)).to_a).to eq(
        Dir["#{adium_fixtures}/AIM.bongo/bongita/*07-23*/*.xml"]
      )
    end
  end

  describe "#between" do
    it "filters the logs by a date range" do
      start = "July 23, 2011"
      stop = Time.new(2011, 7, 24)

      expect(subject.between(start, stop).to_a).to eq(
        Dir["#{adium_fixtures}/AIM.bongo/**/*.xml"]
      )
    end
  end
end
