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
    end
  end
end
