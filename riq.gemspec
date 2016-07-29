# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = 'riq'
  spec.version       = '1.2.7'
  spec.authors       = ['David Brownman']
  spec.email         = ['dbrownman@salesforce.com']
  spec.homepage      = "https://github.com/relateiq/ruby-sdk"
  spec.summary       = 'Ruby SalesforceIQ API client'
  spec.description   = 'Full featured ruby client for interacting with the SalesforceIQ API'
  spec.license       = 'MIT'
  # this works for only adding committed files, but new files don't work until they're committed.
  spec.files         = `git ls-files -z`.split("\x0")
  spec.require_paths = ['lib']

  # 2.0 is min becuase use of refinements
  spec.required_ruby_version = '>= 2.0.0'
  # spec.post_install_message = 'The power of relationship intelligence is in your hands!'

  # prod dependencies
  spec.add_dependency 'httparty', '~> 0.13'

  # dev dependencies
  spec.add_development_dependency 'bundler', '~> 1'
  spec.add_development_dependency 'vcr', '~> 2.9'
  spec.add_development_dependency 'webmock', '~> 1.21'
  spec.add_development_dependency 'minitest', '~> 5.4'
  spec.add_development_dependency 'dotenv', '~> 2'
end
