require "tam_tam/message"

module TamTam
  class MessageSet
    attr_accessor :data
    protected :data

    def initialize(data)
      self.data = data.map { |data| Message.new(data) }
    end

    def containing(phrase)
      data.select! do |message|
        case phrase
        when Regexp
          message.text.match(phrase)
        else
          message.text.include?(phrase)
        end
      end

      self
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
