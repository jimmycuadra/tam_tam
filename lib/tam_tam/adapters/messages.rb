require "tam_tam/adapter"

require "sqlite3"

module TamTam
  module Adapters
    # Adapter for Apple Messages (iChat).
    class Messages < Adapter
      APPLE_EPOCH = 978307200

      attr_accessor :db

      def self.default_path
        "#{Dir.home}/Library/Messages/chat.db"
      end

      def initialize(path = nil)
        super
        self.db = SQLite3::Database.new(self.path)
        db.results_as_hash = true
      end

      def default_matches
      end

      def load_messages(matches)

        sql = %{
          SELECT handle_id, text, date
          FROM message
          WHERE message.ROWID IN (#{matches.map(&:to_i).join(",")})
        }
        messages = db.execute(sql).map do |row|
          {
            sender: row["handle_id"],
            text: row["text"],
            time: Time.at(APPLE_EPOCH + row["date"].to_i).localtime
          }
        end

        handles = get_handles(messages)

        messages.each do |message|
          message[:sender] = handles[message[:sender]]
        end

        messages
      end

      def as(accounts)
      end

      def with(participants)
      end

      def on(start)
      end

      def between(start, stop)
      end

      private

      def get_handles(messages)
        handles = messages.inject({}) do |handles, message|
          handles[message[:sender]] = nil
          handles
        end

        sql = %{
          SELECT ROWID, id
          FROM handle
          WHERE handle.ROWID IN (#{handles.keys.map(&:to_i).join(",")})
        }

        db.execute(sql) do |row|
          handles[row["ROWID"]] = row["id"]
        end

        handles
      end
    end
  end

  register_adapter :messages, Adapters::Messages
end