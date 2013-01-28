# -*- encoding: utf-8 -*-
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tam_tam/version"

Gem::Specification.new do |gem|
  gem.name          = "tam_tam"
  gem.version       = TamTam::VERSION
  gem.authors       = ["Jimmy Cuadra"]
  gem.email         = ["jimmy@jimmycuadra.com"]
  gem.description   = %q{Parse, navigate, and analyze logs from online chat clients.}
  gem.summary       = %q{Parse, navigate, and analyze logs from online chat clients.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency("chronic")
  gem.add_runtime_dependency("nokogiri")
  gem.add_development_dependency("rspec")
  gem.add_development_dependency("debugger")
  gem.add_development_dependency("debugger-pry")
  gem.add_development_dependency("pry")
  gem.add_development_dependency("cane")
  gem.add_development_dependency("simplecov")
end
