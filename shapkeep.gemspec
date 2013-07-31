# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shapkeep/version'

Gem::Specification.new do |spec|
  spec.name          = "shapkeep"
  spec.version       = Shapkeep::VERSION
  spec.authors       = ['j-wilkins']
  spec.email         = ['jake@jakewilkins.com']
  spec.description   = %q{EVAL Lua scripts in Redis by name}
  spec.summary       = %q{EVAL Lua scripts in Redis by name}
  spec.homepage      = ""
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'redis', '~> 3'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
