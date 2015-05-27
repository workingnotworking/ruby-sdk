# RelateIQ Ruby SDK

A full featured API interface for interacting with the [RelateIQ](https://relateiq.com) API. 

## Overview

[![Gem Version](https://img.shields.io/gem/v/riq.svg)](http://badge.fury.io/rb/riq)
[![Build Status](https://img.shields.io/travis/relateiq/ruby-sdk.svg)](https://travis-ci.org/relateiq/ruby-sdk)
[![MIT license](http://img.shields.io/badge/license-MIT-blue.svg)](http://opensource.org/licenses/MIT)

## Code Examples

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


## Helpful Links

* [Full ruby docs](http://www.rubydoc.info/gems/riq)
* [Examples and API docs](https://api.relateiq.com/#/ruby)
