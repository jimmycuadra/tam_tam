module TamTam
  # An individual message. Simple wrapper around a Hash with the message data.
  class Message
    attr_accessor :data
    protected :data

    def initialize(data)
      self.data = data
    end

    def sender
      data[:sender]
    end

    def text
      data[:text]
    end

    def time
      data[:time]
    end

    def ==(other)
      data == other.data
    end
  end
end
