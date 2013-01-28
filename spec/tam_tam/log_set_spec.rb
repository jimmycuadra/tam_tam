require "spec_helper"

describe TamTam::LogSet do
  let(:adapter) do
    adapter = double("adapter")
    adapter.stub(:default_matches) { ["foo"] }
    adapter.stub(:load_messages)
    adapter.stub(:as) { "accounts" }
    adapter.stub(:with) { "participants" }
    adapter.stub(:on) { "time" }
    adapter.stub(:between) { "time range" }
    adapter
  end

  subject { TamTam::LogSet.new(adapter) }

  it "starts with the default matches from the adapter" do
    expect(subject.matches).to eql(subject.adapter.default_matches)
  end

  describe "#messages" do
    let(:messages) { double("messages") }

    before { TamTam::MessageSet.stub(:new).and_return(messages) }

    it "returns a MessageSet with the matches" do
      expect(subject.messages).to eql(messages)
    end

    it "only loads the messages once" do
      TamTam::MessageSet.should_receive(:new).once
      subject.messages
      subject.messages
    end
  end

  describe "#as" do
    it "calls filter with the results of the adapter's #as" do
      subject.should_receive(:filter).with("accounts")
      subject.as("myself")
    end
  end

  describe "#with" do
    it "calls filter with the results of the adapter's #with" do
      subject.should_receive(:filter).with("participants")
      subject.with("someone else")
    end
  end

  describe "#on" do
    it "calls filter with the results of the adapter's #on" do
      subject.should_receive(:filter).with("time")
      subject.on(Time.new)
    end

    it "converts string arguments to Time objects" do
      subject.stub(:filter)
      Chronic.should_receive(:parse).with("today")
      subject.on("today")
    end
  end

  describe "#between" do
    it "calls filter with the results of the adapter's #between" do
      subject.should_receive(:filter).with("time range")
      time = Time.new
      subject.between(time, time)
    end

    it "converts string arguments to Time objects" do
      subject.stub(:filter)
      Chronic.should_receive(:parse).with("yesterday")
      Chronic.should_receive(:parse).with("today")
      subject.between("yesterday", "today")
    end
  end

  describe "#to_s" do
    it "includes the class name, object ID, and path" do
      string = subject.to_s
      expect(string).to match(%r{#<TamTam::LogSet:0x[a-f0-9]+ adapter=.*>})
    end
  end

  describe "#clear_messages_cache" do
    it "clears the messages so they can be regenerated" do
      TamTam::MessageSet.should_receive(:new).twice
      subject.messages
      subject.send(:clear_messages_cache)
      subject.messages
    end
  end

  describe "#filter" do
    it "returns a copy of the set with filtered matches" do
      copy = subject.send(:filter, [])
      expect(copy).not_to eql(subject)
    end
  end
end
