require "tam_tam/messages"

module TamTam
  class Logs
    class << self
      attr_accessor :adapters

      def inherited(base)
        key = base.name.split(/::/).last.downcase.to_sym
        self.adapters[key] = base
      end
    end

    self.adapters = {}

    def initialize(options = {})
    end

    def messages
      Messages.new
    end
  end
end
