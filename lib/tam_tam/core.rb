require "tam_tam/version"
require "tam_tam/log_set"

# The primary entry point for users.
module TamTam
  @adapters ||= {}

  class << self
    def new(options = {})
      adapter_key = options[:adapter]
      adapter_key = :adium if adapter_key.nil? && adapters.include?(:adium)
      adapter_key = adapters.first if adapter_key.nil?
      adapter = @adapters[adapter_key].new(options[:path])
      LogSet.new(adapter)
    end

    def register_adapter(key, adapter)
      @adapters[key] = adapter
    end

    def unregister_adapter(key)
      @adapters.delete(key)
    end

    def adapters
      @adapters.keys
    end
  end
end
