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
      copy = dup
      copy.data = data.select { |message| message.text.include?(phrase) }
      copy
    end

    def matching(pattern)
      copy = dup
      copy.data = data.select { |message| message.text.match(pattern) }
      copy
    end

    def sent_by(sender)
      copy = dup
      copy.data = data.select { |message| message.sender == sender }
      copy
    end

    def by_count
      Hash[group_by { |message| message.text }.inject({}) { |counts, groups|
        counts[groups[0]] = groups[1].size
        counts
      }.sort_by { |key, value| -value }]
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
