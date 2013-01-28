require "spec_helper"

describe TamTam::Adapter do
  def adium_fixtures
    File.expand_path(File.join("..", "..", "fixtures", "adium"), __FILE__)
  end

  subject do
    TamTam.new(path: adium_fixtures)
  end

  describe "to_s" do
    it "shows the object ID as hexadecimal and the path" do
      expect(subject.to_s).to match(
        %r{#<TamTam::Adapters::Adium:0x[0-9a-f]+ path="[\w/]+">}
      )
    end
  end

  describe "#messages" do
    it "returns the messages for the given logs" do
      expect(subject.messages).to be_a(TamTam::MessageSet)
    end
  end

  described_class.singleton_class.send(:abstract_methods).each do |method|
    it "raises an exception if .#{method} is not implemented by the adapter" do
      expect {
        described_class.send(method)
      }.to raise_error(
        TamTam::AbstractMethodError,
        ".#{method} must be defined in the adapter."
      )
    end
  end

  described_class.send(:abstract_methods).each do |method|
    it "raises an exception if ##{method} is not implemented by the adapter" do
      expect {
        TamTam.new(adapter: :test).send(method)
      }.to raise_error(
        TamTam::AbstractMethodError,
        "##{method} must be defined in the adapter."
      )
    end
  end

  describe "#as" do
    it "filters the logs by a single account" do
      expect(subject.as("bongo").matches).to eq(
        Dir["#{adium_fixtures}/AIM.bongo/**/*.xml"]
      )
    end

    it "filters the logs by multiple accounts (with multiple arguments)" do
      expect(subject.as("bongo", "bongo@gmail.com").matches).to eq(
        Dir["#{adium_fixtures}/**/*.xml"]
      )
    end

    it "filters the logs by multiple accounts (with an array)" do
      expect(subject.as(["bongo", "bongo@gmail.com"]).matches).to eq(
        Dir["#{adium_fixtures}/**/*.xml"]
      )
    end

    it "allows chaining" do
      logs = subject.as("bongo").with("rumples@gmail.com").matches

      expect(logs).to be_empty
    end
  end

  describe "#with" do
    it "filters the logs by a single participant" do
      expect(subject.with("bongita").matches).to eq(
        Dir["#{adium_fixtures}/AIM.bongo/**/*.xml"]
      )
    end

    it "filters the logs by multiple participants (with multiple arguments)" do
      expect(subject.with("bongita", "rumples@gmail.com").matches).to eq(
        Dir["#{adium_fixtures}/**/*.xml"]
      )
    end

    it "filters the logs by multiple participants (with an array)" do
      expect(subject.with(["bongita", "rumples@gmail.com"]).matches).to eq(
        Dir["#{adium_fixtures}/**/*.xml"]
      )
    end

    it "allows chaining" do
      logs = subject.with("rumples@gmail.com").as("bongo").matches

      expect(logs).to be_empty
    end
  end

  describe "#on" do
    it "filters the logs by date (as a string)" do
      expect(subject.on("July 23, 2011").matches).to eq(
        Dir["#{adium_fixtures}/AIM.bongo/bongita/*07-23*/*.xml"]
      )
    end

    it "filters the logs by date (as a Time object)" do
      expect(subject.on(Time.new(2011, 7, 23)).matches).to eq(
        Dir["#{adium_fixtures}/AIM.bongo/bongita/*07-23*/*.xml"]
      )
    end

    it "allows chaining" do
      logs = subject.on("July 23, 2011").with("rumples@mail.com").matches

      expect(logs).to be_empty
    end
  end

  describe "#between" do
    it "filters the logs by a date range" do
      start = "July 23, 2011"
      stop = Time.new(2011, 7, 24)

      expect(subject.between(start, stop).matches).to eq(
        Dir["#{adium_fixtures}/AIM.bongo/**/*.xml"]
      )
    end

    it "allows chaining" do
      start = "July 23, 2011"
      stop = Time.new(2011, 7, 24)
      logs = subject.between(start, stop).with("rumples@gmail.com").matches

      expect(logs).to be_empty
    end
  end
end