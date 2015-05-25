require 'minitest/autorun'
# testing!
require 'webmock/minitest'

# disallow actual http requests!
# WebMock.disable_net_connect!(allow_localhost: true)
require_relative '../lib/riq'

describe RIQ::Account do
  before do
    RIQ.init
    # netflix account ID
    @netflix = RIQ.account('54e6542fe4b01ad3b7362bc4')
    @a = RIQ.account
    @dat = RIQ.account({name: 'Glengarry', field_values: {'0' => 3}})
  end

  describe '#new' do
    it 'should get account' do
      puts 'asdqwer'
      stub_request(:get, /accounts\/54e6542fe4b01ad3b7362bc4$/).with(:headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json'}).to_return(status: 200, body: {})
      @netflix.name.must_equal 'Netflix'
    end

    it 'should make blank account' do
      @a.wont_be_nil
    end

    it 'should take a data hash' do 
      @dat = RIQ.account({name: 'David'})
      @dat.name.wont_be_nil
    end
  end

  describe '#save' do 
    it 'should create new account' do
      @a.name = 'Delete Test Inc'
      @a.field_value(2, '1')
      @a.save

      @a.id.wont_be_nil
    end
  end

  describe "#field_value" do
    it 'should fetch a field value' do 
      @netflix.field_value(2).wont_be_nil
      @dat.field_value(0).wont_be_nil
    end
  end
end