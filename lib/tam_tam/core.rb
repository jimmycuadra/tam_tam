require "tam_tam/version"

# Public: The primary interface for creating new LogSet objects. Also
# responsible for keeping a global registry of adapters.
module TamTam
  @adapters ||= {}

  class << self
    # Public: Initialize a new LogSet. Uses the specified adapter, else Adium
    # if it's registered, else the first registered adapter.
    #
    # options - The Hash options used to determine the adapter and its options.
    #           (default: {}):
    #         :adapter  - A Symbol specifying the adapter to use.
    #         :path     - A String file path to the log files for this client.
    #
    # Returns a new LogSet.
    def new(options = {})
      adapter_key = options[:adapter]
      adapter_key = :adium if adapter_key.nil? && adapters.include?(:adium)
      adapter_key = adapters.first if adapter_key.nil?
      adapter = @adapters[adapter_key].new(options[:path])
      LogSet.new(adapter)
    end

    # Public: Register a chat adapter.
    #
    # key     - The Symbol to register the adapter under.
    # adapter - A Class implementing the adapter interface.
    #
    # Returns the adapter.
    def register_adapter(key, adapter)
      @adapters[key] = adapter
    end

    # Public: Remove a chat adapter from the registry.
    #
    # key - The Symbol key of the adapter to remove.
    #
    # Returns the removed adapter.
    def unregister_adapter(key)
      @adapters.delete(key)
    end

    # Public: A list of registered adapters.
    #
    # Returns an Array of Symbol adapter keys.
    def adapters
      @adapters.keys
    end
  end
end
