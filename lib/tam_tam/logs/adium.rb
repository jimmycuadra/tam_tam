require "tam_tam/logs"

module TamTam
  class Logs
    class Adium < Logs
      class << self
        def default_path
          "~/Library/Application Support/Adium 2.0/Users/Default/Logs"
        end
      end

      def to_a
        Dir["#{path}/**/*.xml"]
      end

      def as(*accounts)
        Dir["#{path}/*\.{#{accounts.join(',')}}/**/*.xml"]
      end

      def with(*participants)
        Dir["#{path}/*\.*/{#{participants.join(',')}}/**/*.xml"]
      end
    end
  end
end
