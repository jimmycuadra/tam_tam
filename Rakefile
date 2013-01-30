require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "cane/rake_task"

RSpec::Core::RakeTask.new(:spec)
Cane::RakeTask.new(:quality) do |cane|
  cane.add_threshold "coverage/covered_percent", :>=, 100
end

task :default => [:spec, :quality]
