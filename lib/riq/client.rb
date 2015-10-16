require 'httparty'
require 'json'
require_relative 'error'

module RIQ
  # HTTP client responsible for actually handling the HTTP requests.
  # @note Utility class to perform HTTP requests. This shouldn't be
  #   instantiated directly but used by children of RIQObject instead.
  class Client
    attr_accessor :cache

    def initialize(key, secret)
      raise 'Missing credentials' if key.nil? || secret.nil?

      @root_url = 'https://api.salesforceiq.com/v2'

      @auth = {username: key, password: secret}
      @headers = {
        'Content-type' => 'application/json', 
        'Accept' => 'application/json'
      }
      @cache = {}
    end
      
    # for caching, used with #next ? 
    # def store(endpoint, objects)
      # @cache[endpoint] = objects unless objects.nil?
    # end

    # Makes a GET request, used for fetching existing objects.
    # @return (see #request)
    def get(endpoint, options: nil)
      request(endpoint, :get, nil, options)
    end

    # Makes a POST request, used for creating new objects.
    # @return (see #request)
    def post(endpoint, body, options: nil)
      request(endpoint, :post, body, options)
    end

    # Makes a PUT request, used for updating existing objects.
    # @return (see #request)
    def put(endpoint, body, options: nil)
      request(endpoint, :put, body, options)
    end

    # Makes a DELETE request, used for deleting existing objects.
    # @return (see #request)
    def delete(endpoint, options: nil)
      request(endpoint, :delete, nil, options)
    end

    private

    # actually does the requesting
    # @return (see #process_response)
    def request(endpoint, method = :get, body = nil, options = nil)
      # there may be a better way to do this, but this is close
      url = "#{@root_url}/#{endpoint}"
      # pp "#{method} request to #{url} with body: #{body} and options: #{options}"
      if [:get, :delete].include? method
        resp = HTTParty.method(method).call(
          url, 
          headers: @headers, 
          basic_auth: @auth, 
          query: options
        )
      elsif [:post, :put].include? method
        resp = HTTParty.method(method).call(
          url, 
          headers: @headers, 
          basic_auth: @auth, 
          query: options, 
          body: body
        )
      else
        # this shouldn't ever get hit?
        raise RIQError, 'Invalid method'
      end
      
      # HTTParty response object
      process_response(resp)
    end

    def process_response(resp)
      # pp "processing #{resp}, code: #{resp.code}"
      # puts resp.parsed_response['name']
      if resp.code == 503
        raise NotImplementedError, 'This function is not currently supported by SalesforceIQ'
      elsif resp.code == 404 
        raise NotFoundError, 'Object Not Found'
      elsif resp.code >= 400 
        # Record Response Data
        raise HTTPError, resp 
      end
      # 404 Object not found
      #    if List, have them check if it is shared
      # 500
      # 422
      # 400 Bad Request - pass on internal message
      # 502 Bad Gateway - Reattempt
      
      # if resp.include? 'objects'
      #   resp['objects']
      # else
      resp.parsed_response
      # end
    end
  end

  class << self  
    # @param key [String] SalesforceIQ API key
    # @param secret [String] SalesforceIQ API secret
    # @return [RIQ] The module, in case you want it.
    def init(key = nil, secret = nil)
      key ||= ENV['RIQ_TEST_API_KEY']
      secret ||= ENV['RIQ_TEST_API_SECRET']

      @@client = Client.new(key, secret)
      self
    end

    # Always use RIQ.client to retrieve the client object.
    # @return [Client] The client object
    def client
      raise RIQError, 'Client not initialized' unless defined?(@@client)
      @@client
    end
  end
end
