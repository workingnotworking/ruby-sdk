# coding: utf-8
# lib = File.expand_path('../lib', __FILE__)
# $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'riq'
  spec.version       = '1.0.2'
  spec.authors       = ['David Brownman']
  spec.email         = ['david@relateiq.com']
  spec.homepage      = "https://github.com/relateiq/ruby-sdk"
  spec.summary       = 'Ruby RIQ API client'
  spec.description   = 'Full featured ruby client for interacting with the RelateIQ API'
  spec.license       = 'MIT'
  spec.files         = `git ls-files -z`.split("\x0")
  # spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  # 2.0 is min becuase use of refinements
  spec.required_ruby_version = '>= 2.0.0'
  # spec.post_install_message = 'The power of relationship intelligence is in your hands!'

  # prod dependencies
  spec.add_dependency 'httparty', '0.13.3'

  # dev dependencies
  spec.add_development_dependency 'bundler', '~> 1.7'
  # spec.add_development_dependency 'rake', '~> 10.0'
end
