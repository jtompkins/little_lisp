# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'little_lisp/version'

Gem::Specification.new do |spec|
  spec.name          = 'little_lisp'
  spec.version       = LittleLisp::VERSION
  spec.authors       = ['Joshua Tompkins']
  spec.email         = ['josh@joshtompkins.com']

  spec.summary       = "A Ruby implementation of Mary Rose Cook's Little Lisp"
  spec.homepage      = 'https://github.com/jtompkins/little_lisp'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir = 'bin'
  spec.executables << 'little_lisp'
  spec.require_paths = ['lib']

  spec.add_development_dependency 'trollop'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rubocop', '~> 0.47.1'
end
