require "simplecov"
SimpleCov.start { add_filter "spec" }

require "pry"
require "debugger"
require "debugger/pry"

require "tam_tam"

module TamTam
  module Adapters
    class Test < Adapter
      def self.default_path
        ""
      end

      def default_matches
        []
      end
    end
  end

  register_adapter :test, Adapters::Test
end
