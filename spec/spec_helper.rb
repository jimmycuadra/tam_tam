require "simplecov"

class SimpleCov::Formatter::QualityFormatter
  def format(result)
    SimpleCov::Formatter::HTMLFormatter.new.format(result)
    File.open("coverage/covered_percent", "w") do |f|
      f.puts result.source_files.covered_percent.to_i
    end
  end
end

SimpleCov.formatter = SimpleCov::Formatter::QualityFormatter
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
