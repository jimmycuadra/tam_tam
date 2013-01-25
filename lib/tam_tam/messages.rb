require "tam_tam/message"

module TamTam
  class Messages
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

    protected

    def messages
      @messages
    end
  end
end
