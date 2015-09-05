# -*- encoding: utf-8 -*-
lib = File.join(File.dirname(File.expand_path(__FILE__)), 'lib')
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'musca/version'
require 'rake'

Gem::Specification.new do |gem|
  gem.name = 'musca'
  gem.version = Musca::VERSION
  gem.authors = ['Ryan Breed']
  gem.email = ['opensource@breed.org']
  gem.description  = 'basic CA manager'
  gem.summary = 'Initializes a certificate authority for a standalone hierarchy'
  gem.homepage = 'https://github.com/ryanbreed/musca'
  gem.files = FileList[
    'lib/**/*.rb',
    'bin/*',
    '[A-Z]*',
    'templates/*'
  ].to_a
  gem.executables = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
  gem.add_runtime_dependency 'thor'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rubocop'
  gem.add_development_dependency 'guard'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'guard-rubocop'
  gem.add_development_dependency 'guard-bundler'
  gem.add_development_dependency 'simplecov'
end
