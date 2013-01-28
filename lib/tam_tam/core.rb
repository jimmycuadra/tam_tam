require "tam_tam/version"

module TamTam
  @adapters ||= {}

  class << self
    def new(options = {})
      adapter = options.delete(:adapter)
      adapter = :adium if adapter.nil? && @adapters[:adium]
      adapter = @adapters.keys.first if adapter.nil?
      @adapters[adapter].new(options)
    end

    def register_adapter(key, adapter)
      @adapters[key] = adapter
    end
  end
end
