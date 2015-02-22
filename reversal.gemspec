# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'reversal/version'

Gem::Specification.new do |spec|
  spec.add_development_dependency 'bundler', '~> 1.0'
  spec.authors = ['coilo']
  spec.description = 'A computer reversi written in Ruby'
  spec.email = ['coilo.dev@gmail.com']
  spec.files = Dir.glob('lib/**/*.rb')
  spec.homepage = 'https://github.com/coilo/reversal'
  spec.licenses = ['MIT']
  spec.name = 'reversal'
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.1.0'
  spec.version = Reversal::VERSION.dup
end
