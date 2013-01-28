require "chronic"

require "tam_tam/message_set"

module TamTam
  class AbstractMethodError < StandardError; end

  class Logs
    class << self
      attr_accessor :adapters

      def inherited(base)
        name = base.name

        if name.nil?
          key = :test
        else
          key = name.split(/::/).last.downcase.to_sym
        end

        self.adapters[key] = base
      end

      private

      def self.abstract_methods
        [:default_path, :default_matches]
      end

      abstract_methods.each do |method|
        define_method(method) do
          raise AbstractMethodError.new(
            ".#{method} must be defined in the adapter."
          )
        end
      end
    end

    self.adapters = {}

    attr_accessor :path, :matches

    def initialize(options = {})
      self.path = options[:path] || self.class.default_path
      self.matches = self.class.default_matches(path)
    end

    def to_a
      matches
    end

    def to_s
      %{#<#{self.class.name}:0x#{object_id.to_s(16)} path="#{path}">}
    end

    alias_method :inspect, :to_s

    private

    def self.abstract_methods
      [:messages, :as, :with, :on, :between]
    end

    abstract_methods.each do |method|
      define_method(method) do
        raise AbstractMethodError.new(
          "##{method} must be defined in the adapter."
        )
      end
    end

    def add_filter(filter_matches)
      self.matches = matches & filter_matches
      self
    end
  end
end
