require 'minitest/autorun'
require_relative '../lib/riq'

describe RIQ::Contact do
  before do
    RIQ.init
    # sammy's contact ID
    @sammy = RIQ.contact('542b205be4b04cd81270dff9')
    @c = RIQ.contact
    @dat = RIQ.contact({properties: {'name' => ['david'], email: ['dab@relateiq.com']}})
  end

  describe '#new' do
    it 'should get account' do
      @sammy.name.must_include 'Sammy Nammari'
    end

    it 'make blank contact' do
      @c.wont_be_nil
    end
  end

  describe '#save' do 
    it 'should create new contact and delete it' do
      @c.add(:name, 'Ron Mexico')
      @c.save

      @c.id.wont_be_nil

      assert(@c.delete)
    end
  end

  describe 'properties' do 
    it "should add new emails only if they're new" do
      @sammy.email.must_equal @sammy.add(:email, 'nammari@stanford.edu')

      @sammy.email.wont_equal @sammy.add(:email, 'jammari@stanford.edu')      
    end

    it 'should only take strings as properties' do
      @c.add(:phone, '867-5309').wont_be_empty

      begin
        @c.add(:name, {value: 'Jenny'})
      rescue RIQ::RIQError
        nil.must_be_nil
      else
        1.must_be_nil
      end
    end
  end

  describe '#upsert' do 
    it 'should upsert' do
      # this could be better
      @sammy.email.must_equal @sammy.upsert.email

      # should add another assertion with the blank contact
    end
  end
end