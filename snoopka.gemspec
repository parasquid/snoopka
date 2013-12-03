# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'snoopka/version'

Gem::Specification.new do |spec|
  spec.name          = "snoopka"
  spec.version       = Snoopka::VERSION
  spec.authors       = ["tristan"]
  spec.email         = ["tristan.gomez@gmail.com"]
  spec.description   = %q{Listens to a Kafka server and executes provided block}
  spec.summary       = %q{Listens to a Kafka server and executes provided block}
  spec.homepage      = "https://github.com/parasquid/snoopka"
  spec.license       = "LGPLv3"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"

  spec.add_runtime_dependency "kafka-rb"
end
