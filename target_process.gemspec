lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'target_process/version'

Gem::Specification.new do |spec|
  spec.name          = "target_process"
  spec.version       = TargetProcess::VERSION
  spec.authors       = ["Dmitry Brodnitskiy", "Yura Tolstik"]
  spec.email         = ["dm.brodnitskiy@gmail.com", "yltsrc@gmail.com"]
  spec.description   = %q{ruby wrapper for TargetProcess JSON REST API}
  spec.summary       = %q{ruby wrapper for TargetProcess JSON REST API}
  spec.homepage      = "http://rubygems.org/gems/target_process"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">=2.14.0"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock", ">= 1.8.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "simplecov-gem-adapter"
  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "httparty"
  spec.add_runtime_dependency "json"
end
