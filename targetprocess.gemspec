lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'targetprocess/version'

Gem::Specification.new do |spec|
  spec.name          = "targetprocess"
  spec.version       = Targetprocess::VERSION
  spec.authors       = ["Dmitry Brodnitskiy"]
  spec.email         = ["dm.brodnitskiy@gmail.com"]
  spec.description   = %q{Targetprocess ruby wrapper}
  spec.summary       = %q{}
  spec.homepage      = "http://rubygems.org/gems/targetprocess"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">=2.14.0"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock", "~>1.8"
  spec.add_runtime_dependency "activesupport", ">=3.2.14"
  spec.add_runtime_dependency "httparty"
  spec.add_runtime_dependency "oj"
end
