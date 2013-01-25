module TamTam
  class Message
    def initialize(data)
      @data = data
    end

    def text
      @data[:text]
    end

    def ==(other)
      data == other.data
    end

    protected

    def data
      @data
    end
  end
end
