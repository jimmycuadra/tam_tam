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

  let(:adapter_without_instance_methods) do
    klass = Class.new(described_class)

    described_class.singleton_class.abstract_methods.each do |method|
      klass.stub(method)
    end

    klass
  end

  described_class.send(:abstract_methods).each do |method|
    it "raises an exception if ##{method} is not implemented by the adapter" do
      expect {
        adapter_without_instance_methods.new.send(method)
      }.to raise_error(
        TamTam::AbstractMethodError,
        "##{method} must be defined in the adapter."
      )
    end
  end

  describe "#to_a" do
    it "returns an array of all log file paths" do
      expect(subject.to_a).to eq(Dir["#{adium_fixtures}/**/*.xml"])
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

    it "allows chaining" do
      logs = subject.as("bongo").with("rumples@gmail.com").to_a

      expect(logs).to be_empty
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

    it "allows chaining" do
      logs = subject.with("rumples@gmail.com").as("bongo").to_a

      expect(logs).to be_empty
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

    it "allows chaining" do
      logs = subject.on("July 23, 2011").with("rumples@mail.com").to_a

      expect(logs).to be_empty
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

    it "allows chaining" do
      start = "July 23, 2011"
      stop = Time.new(2011, 7, 24)
      logs = subject.between(start, stop).with("rumples@gmail.com").to_a

      expect(logs).to be_empty
    end
  end
end
