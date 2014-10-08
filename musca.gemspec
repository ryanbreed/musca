# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'femc-ca/version'
require 'rake'

Gem::Specification.new do |gem|
  gem.name          = "femc-ca"
  gem.version       = Femc::Ca::VERSION
  gem.authors       = ["Ryan Breed"]
  gem.email         = ["opensource@breed.org"]
  gem.description   = %q{basic CA manager for femc server and client}
  gem.summary       = %q{Initializes a certificate authority for a standalone hierarchy}
  gem.homepage      = ""

  gem.files         = FileList["lib/**/*.rb",
                      "bin/*",
                      "[A-Z]*",
                      "templates/*"].to_a
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_runtime_dependency     "thor"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "rspec"
end
