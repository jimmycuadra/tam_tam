require "tam_tam/message"

module TamTam
  class MessageSet
    include Enumerable

    attr_accessor :data
    protected :data

    def initialize(data)
      self.data = data.map { |data| Message.new(data) }
    end

    def including(phrase)
      data.select! { |message| message.text.include?(phrase) }
      self
    end

    def matching(pattern)
      data.select! { |message| message.text.match(pattern) }
      self
    end

    def each
      data.each { |message| yield message }
    end

    def ==(other)
      data == other.data
    end

    def to_s
      %{#<#{self.class.name}:0x#{object_id.to_s(16)} size=#{size}>}
    end

    alias_method :inspect, :to_s

    def size
      data.size
    end

    alias_method :length, :size
  end
end
