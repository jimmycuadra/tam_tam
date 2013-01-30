require "tam_tam/message_set"

require "chronic"

module TamTam
  # A set of chat logs. Responsible for filtering at the chat log level.
  # Delegates to the adapter for client-specific behavior.
  class LogSet
    attr_accessor :adapter, :matches

    def initialize(adapter)
      self.adapter = adapter
      self.matches = adapter.default_matches
    end

    def messages
      @messages ||= MessageSet.new(adapter.load_messages(matches))
    end

    def as(*accounts)
      filter(adapter.as(accounts))
    end

    def with(*participants)
      filter(adapter.with(participants))
    end

    def on(start)
      start = Chronic.parse(start) if start.is_a?(String)
      filter(adapter.on(start))
    end

    def between(start, stop)
      start = Chronic.parse(start) if start.is_a?(String)
      stop = Chronic.parse(stop) if stop.is_a?(String)
      filter(adapter.between(start, stop))
    end

    def to_s
      %{#<#{self.class.name}:0x#{object_id.to_s(16)} adapter=#{adapter.to_s}>}
    end
    alias_method :inspect, :to_s

    protected

    def clear_messages_cache
      @messages = nil if defined?(@messages)
    end

    private

    def filter(filter_matches)
      copy = dup
      copy.clear_messages_cache
      copy.matches = matches & filter_matches
      copy
    end
  end
end
