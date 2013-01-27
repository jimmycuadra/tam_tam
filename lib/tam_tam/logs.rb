require "tam_tam/messages"

module TamTam
  class AbstractMethodError < StandardError; end

  class Logs
    class << self
      attr_accessor :adapters

      def inherited(base)
        key = base.name.split(/::/).last.downcase.to_sym
        self.adapters[key] = base
      end

      def default_path
        raise AbstractMethodError
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
  end
end
