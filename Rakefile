require "bundler/gem_tasks"
require "cane/rake_task"

desc "Run cane to check quality metrics"
Cane::RakeTask.new(:quality) do |cane|
  cane.no_doc = true
end

task :default => :quality
