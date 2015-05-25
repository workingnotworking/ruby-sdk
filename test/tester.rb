# testing!
require 'webmock/minitest'

# disallow actual http requests!
WebMock.disable_net_connect!(allow_localhost: true)

# require everything to run all tests
Dir["#{__dir__}/*_*.rb"].each{|f| require_relative f}