require "spec_helper"

describe TamTam::Adapter do
  it "uses a specified path" do
    adapter = described_class.new("/foo")
    expect(adapter.path).to eq("/foo")
  end

  it "uses .default_path if no path is specified" do
    expect {
      subject
    }.to raise_error(NoMethodError)
  end

  describe "#to_s" do
    it "includes the class name, object ID, and path" do
      string = described_class.new("/foo").to_s
      expect(string).to match(%r{#<TamTam::Adapter:0x[a-f0-9]+ path="/foo">})
    end
  end

  %w[default_matches load_messages as with on between].each do |method|
    it "raises an error if ##{method} is not defined" do
      expect {
        described_class.new("/foo").send(method)
      }.to raise_error(TamTam::AbstractMethodError)
    end
  end
end
