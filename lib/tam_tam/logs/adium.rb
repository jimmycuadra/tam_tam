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

      def on(start)
        start = Chronic.parse(start.to_s)

        Dir["#{path}/**/*#{start.to_date.to_s}*/*.xml"]
      end

      def between(start, stop)
        start = Chronic.parse(start.to_s).to_date
        stop = Chronic.parse(stop.to_s).to_date

        Dir["#{path}/**/*.xml"].select do |log|
          match = log.match(/(\d{4})-(\d{2})-(\d{2})/)
          log_date = Time.new(match[1], match[2], match[3]).to_date
          log_date >= start && log_date <= stop
        end
      end
    end
  end
end
