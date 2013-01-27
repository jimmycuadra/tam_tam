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

      def default_path
        raise AbstractMethodError.new(
          ".default_path must be defined in the subclass."
        )
      end
    end

    self.adapters = {}

    attr_accessor :path

    def initialize(options = {})
      self.path = options[:path] || self.class.default_path
    end

    def messages
      Messages.new
    end

    [:to_a, :as, :with, :on, :between].each do |method|
      define_method(method) do
        raise AbstractMethodError.new(
          "##{method} must be defined in the subclass."
        )
      end
    end
  end
end
