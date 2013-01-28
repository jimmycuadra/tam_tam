require "tam_tam/version"

module TamTam
  class << self
    def new(options = {})
      adapter = Logs.adapters[options.delete(:adapter) || :adium]
      adapter.new(options)
    end
  end
end
