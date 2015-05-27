# testing!
require 'vcr'

VCR.configure do |c|
  # important so the api keys don't matter
  # need to match body for event cassettes, need to match query for anything with contacts/li/accounts
  c.default_cassette_options = {match_requests_on: [:method, :path, :query, :body], record: :new_episodes}
  
  c.cassette_library_dir = 'vcr_cassettes'
  c.filter_sensitive_data('<API_KEY>') { ENV['RIQ_TEST_API_KEY'] }
  c.filter_sensitive_data('<API_SECRET>') { ENV['RIQ_TEST_API_SECRET'] }
  
  c.hook_into :webmock
  c.before_record do |request|
    # this prevents binary data from being written into the vcr
    if request.response.body.encoding == Encoding::ASCII_8BIT
      request.response.body = request.response.body.force_encoding('utf-8')
    end
  end
  # grab them all 
  # https://stackoverflow.com/questions/16533980/using-specific-vcr-cassette-based-on-request
  c.around_http_request do |request|
    VCR.use_cassette('global', &request)
  end
end


# require everything to run all tests
Dir["#{__dir__}/*_*.rb"].each{|f| require_relative f}