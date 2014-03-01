# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dskiplist/version'

Gem::Specification.new do |spec|
  spec.name          = "dskiplist"
  spec.version       = Dskiplist::VERSION
  spec.authors       = ["Forrest Allison"]
  spec.email         = ["light24bulbs@gmail.com"]
  spec.summary       = %q{High speed skiplist gem}
  spec.homepage      = "https://github.com/light24bulbs/dynamic-skiplist/"
  spec.license       = "MIT"
  spec.required_ruby_version = '>= 1.9.3'
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.add_runtime_dependency "facter"
  spec.add_runtime_dependency "thread_safe"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
end
