# -*- encoding: utf-8 -*-
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tam_tam/version"

Gem::Specification.new do |gem|
  gem.name          = "tam_tam"
  gem.version       = TamTam::VERSION
  gem.authors       = ["Jimmy Cuadra"]
  gem.email         = ["jimmy@jimmycuadra.com"]
  gem.description   = %q{Statitics about your conversations from online chat logs.}
  gem.summary       = %q{Statitics about your conversations from online chat logs.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency("rspec")
  gem.add_development_dependency("pry")
  gem.add_development_dependency("cane")
  gem.add_development_dependency("simplecov")
end
