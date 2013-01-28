module TamTam
  class Message
    attr_accessor :data
    protected :data

    def initialize(data)
      self.data = data
    end

    def text
      data[:text]
    end

    def ==(other)
      data == other.data
    end
  end
end
