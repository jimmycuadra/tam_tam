require "simplecov"
SimpleCov.start

require "pry"
require "debugger"
require "debugger/pry"

require "tam_tam"

module TamTam
  module Adapters
    class Test < Adapter
      class << self
        def default_path
          ""
        end

        def default_matches(path)
          []
        end
      end
    end
  end

  register_adapter :test, Adapters::Test
end
