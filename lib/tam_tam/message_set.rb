require "tam_tam/message"

module TamTam
  class MessageSet
    def initialize(messages = [])
      messages = [messages] unless messages.is_a?(Array)

      @messages = messages.map do |message|
        if message.instance_of?(Message)
          message
        else
          Message.new(message)
        end
      end
    end

    def containing(phrase)
      filtered_messages = @messages.select do |message|
        case phrase
        when Regexp
          message.text.match(phrase)
        else
          message.text.include?(phrase)
        end
      end

      self.class.new(filtered_messages)
    end

    def ==(other)
      messages == other.messages
    end

    def to_s
      %{#<#{self.class.name}:0x#{object_id.to_s(16)} size=#{size}>}
    end

    alias_method :inspect, :to_s

    def size
      @messages.size
    end

    alias_method :length, :size

    protected

    def messages
      @messages
    end
  end
end
