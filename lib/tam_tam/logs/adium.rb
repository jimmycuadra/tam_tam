require "chronic"
require "nokogiri"

require "tam_tam/logs"

module TamTam
  class Logs
    class Adium < Logs
      class << self
        def default_path
          "#{Dir.home}/Library/Application Support/Adium 2.0/Users/Default/Logs"
        end

        def default_matches(path)
          Dir["#{path}/**/*.xml"]
        end
      end

      def as(*accounts)
        add_filter(Dir["#{path}/*\.{#{accounts.join(',')}}/**/*.xml"])
      end

      def with(*participants)
        add_filter(Dir["#{path}/*\.*/{#{participants.join(',')}}/**/*.xml"])
      end

      def on(start)
        start = Chronic.parse(start.to_s)

        add_filter(Dir["#{path}/**/*#{start.to_date.to_s}*/*.xml"])
      end

      def between(start, stop)
        start = Chronic.parse(start.to_s).to_date
        stop = Chronic.parse(stop.to_s).to_date

        filter_matches = Dir["#{path}/**/*.xml"].select do |log|
          match = log.match(/(\d{4})-(\d{2})-(\d{2})/)
          log_date = Time.new(match[1], match[2], match[3]).to_date
          log_date >= start && log_date <= stop
        end

        add_filter(filter_matches)
      end

      def messages
        return @messages if @messages

        data = matches.map do |log_path|
          xml = File.read(log_path)
          doc = Nokogiri.parse(xml)

          doc.css("chat message").map do |message|
            {
              sender: message.attribute("sender").value,
              text: message.text,
              time: Chronic.parse(message.attribute("time").value)
            }
          end
        end.flatten

        @messages = MessageSet.new(data)
      end
    end
  end
end
