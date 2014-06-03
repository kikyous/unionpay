# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'unionpay/version'

Gem::Specification.new do |spec|
  spec.name          = "unionpay"
  spec.version       = UnionPay::VERSION
  spec.authors       = ["Chen"]
  spec.email         = ["kikyous@163.com"]
  spec.description   = %q{An unofficial unionpay gem}
  spec.summary       = %q{An unofficial unionpay gem}
  spec.homepage      = "https://github.com/kikyous/unionpay"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rack"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
