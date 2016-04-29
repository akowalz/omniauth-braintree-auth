# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth-braintree-auth/version'

Gem::Specification.new do |spec|
  spec.name          = "omniauth-braintree-auth"
  spec.version       = OmniAuth::BraintreeAuth::VERSION
  spec.authors       = ["Alex Kowalczuk"]
  spec.email         = ["askowalczuk93@gmail.com"]

  spec.summary       = %q{OmniAuth Strategy for Braintree Auth}
  spec.homepage      = "https://github.com/akowalz/omniauth-braintree-auth"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency 'omniauth', '~> 1.0'
  spec.add_dependency 'faraday_middleware', '~> 0.10.0'
  spec.add_dependency 'omniauth-oauth2', '~> 1.3.1'
end
