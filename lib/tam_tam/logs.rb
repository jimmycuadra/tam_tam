require "chronic"

require "tam_tam/messages"

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

      [:default_path, :default_matches].each do |method|
        define_method(method) do
          raise AbstractMethodError.new(
            ".#{method} must be defined in the subclass."
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

    def messages
      Messages.new
    end

    def to_a
      matches
    end

    [:as, :with, :on, :between].each do |method|
      define_method(method) do
        raise AbstractMethodError.new(
          "##{method} must be defined in the subclass."
        )
      end
    end

    private

    def add_filter(filter_matches)
      self.matches = matches & filter_matches
      self
    end
  end
end
