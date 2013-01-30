require "tam_tam/adapter"

require "nokogiri"

module TamTam
  module Adapters
    # Adapter for Adium. http://adium.im/
    class Adium < Adapter
      def self.default_path
        "#{Dir.home}/Library/Application Support/Adium 2.0/Users/Default/Logs"
      end

      def default_matches
        Dir["#{path}/**/*.xml"]
      end

      def load_messages(matches)
        matches.map do |log_path|
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
      end

      def as(accounts)
        Dir["#{path}/*\.{#{accounts.join(',')}}/**/*.xml"]
      end

      def with(participants)
        Dir["#{path}/*\.*/{#{participants.join(',')}}/**/*.xml"]
      end

      def on(start)
        Dir["#{path}/**/*#{start.to_date.to_s}*/*.xml"]
      end

      def between(start, stop)
        start = start.to_date
        stop = stop.to_date

        default_matches.select do |log|
          match = log.match(/(\d{4})-(\d{2})-(\d{2})/)
          log_date = Time.new(match[1], match[2], match[3]).to_date
          log_date >= start && log_date <= stop
        end
      end
    end
  end

  register_adapter :adium, Adapters::Adium
end
