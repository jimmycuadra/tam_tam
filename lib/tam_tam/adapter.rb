require "tam_tam/core"
require "tam_tam/log_set"

module TamTam
  class AbstractMethodError < StandardError; end

  class Adapter
    attr_accessor :path

    def initialize(path = nil)
      self.path = path || self.class.default_path
    end

    def to_s
      %{#<#{self.class.name}:0x#{object_id.to_s(16)} path="#{path}">}
    end
    alias_method :inspect, :to_s

    %w[default_matches load_messages as with on between].each do |method|
      define_method(method) do
        raise AbstractMethodError.new(
          "##{method} must be defined in the adapter."
        )
      end
    end
  end
end
