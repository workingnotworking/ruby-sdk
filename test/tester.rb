# testing!
require 'vcr'

VCR.configure do |c|
  # important so the api keys don't matter
  c.default_cassette_options = {match_requests_on: [:method, :path]}
  
  c.cassette_library_dir = 'vcr_cassettes'
  c.filter_sensitive_data('<API_KEY>') { ENV['RIQ_TEST_API_KEY'] }
  c.filter_sensitive_data('<API_SECRET>') { ENV['RIQ_TEST_API_SECRET'] }
  
  c.hook_into :webmock

  c.around_http_request do |request|
    VCR.use_cassette('global', :record => :new_episodes, &request)
  end
end


# require everything to run all tests
Dir["#{__dir__}/*_*.rb"].each{|f| require_relative f}