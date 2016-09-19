# SalesforceIQ Ruby SDK

Moved to [siq-ruby-sdk](https://github.com/relateiq/siq-ruby-sdk).

[![Gem Version](https://img.shields.io/gem/v/riq.svg)](http://badge.fury.io/rb/riq)
[![Build Status](https://img.shields.io/travis/relateiq/ruby-sdk.svg)](https://travis-ci.org/relateiq/ruby-sdk)


A full featured native Ruby interface for interacting with the [SalesforceIQ](https://salesforceiq.com)(formerly RelateIQ) API. 

## Status

|Badge (click for more info)|Explanation|
|---|---|
|[![](https://img.shields.io/badge/documentation-100%25-brightgreen.svg)](http://www.rubydoc.info/gems/riq)|% of methods documented|
|[![Code Climate](https://img.shields.io/codeclimate/coverage/github/relateiq/ruby-sdk.svg)](https://codeclimate.com/github/relateiq/ruby-sdk/coverage)|% of methods tested|
|[![Code Climate](https://img.shields.io/codeclimate/github/relateiq/ruby-sdk.svg)](https://codeclimate.com/github/relateiq/ruby-sdk/code)|Overall code quality (4.0 is best)|
|[![Gemnasium](https://img.shields.io/gemnasium/relateiq/ruby-sdk.svg)](https://gemnasium.com/relateiq/ruby-sdk)|Dependency freshness|
|[![MIT license](http://img.shields.io/badge/license-MIT-blue.svg)](http://opensource.org/licenses/MIT)|What can you use this for?|


## Code Examples

``` ruby
require 'riq'
RIQ.init(ENV['RIQ_API_KEY'], ENV['RIQ_API_SECRET'])

# Contacts
RIQ.contacts.each do |c|
    # do something
    puts c.name
end

# => Bruce Wayne
# => Malcolm Reynolds
# => Michael Bluth
# => Tony Stark
...
# Etc

```

## Testing

Copy `.env.example` to `.env` and edit to add your SalesforceIQ account credentials. Then run the Rake task:

    rake test

## Helpful Links

* [Full ruby documentation](http://www.rubydoc.info/gems/riq)
* [Examples and API docs](https://api.salesforceiq.com/#/ruby)
