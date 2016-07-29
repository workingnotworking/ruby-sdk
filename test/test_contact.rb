require_relative 'test_helper'

def create_sammy
  RIQ.contact('579bb1d3e4b0cb31c3328e56')
end

def create_blank_contact
  RIQ.contact  
end

def create_data
  RIQ.contact({properties: {'name' => ['david'], email: ['dab@relateiq.com']}})
end

describe RIQ::Contact do
  describe '#new' do
    it 'should get account' do
      @sammy = create_sammy
      @sammy.name.must_include 'James McSales'
    end

    it 'should make blank contact' do
      @c = create_blank_contact
      @c.wont_be_nil
    end

    it 'should take a data hash' do
      @dat = create_data
    end
  end

  describe '#name' do
    it 'returns an array of property values' do
      @sammy = create_sammy
      @sammy.name.must_equal ['James McSales']
    end
  end

  describe '#primary_name' do
    it 'returns the preferred property value' do
      @sammy = create_sammy
      @sammy.primary_name.must_equal 'James McSales'
    end
  end

  describe '#email' do
    it 'returns an array of property values' do
      @sammy = create_sammy
      @sammy.email.must_equal ['james.mcsales@salesforceiq.com', 'jimmy@personal.com']
    end
  end

  describe '#primary_email' do
    it 'returns the preferred property value' do
      @sammy = create_sammy
      @sammy.primary_email.must_equal 'james.mcsales@salesforceiq.com'
    end
  end

  describe '#save' do 
    it 'should create new contact and delete it' do
      @c = create_blank_contact
      @c.add(:name, 'Ron Mexico')
      @c.save

      @c.id.wont_be_nil
      @c.state.wont_be_nil

      assert @c.delete
    end
  end

  describe 'properties' do 
    it "should add new emails only if they're new" do
      @sammy = create_sammy
      @sammy.email.must_equal @sammy.add(:email, 'jimmy@personal.com')

      @sammy.email.wont_equal @sammy.add(:email, 'jammari@stanford.edu')      
    end

    it 'should only take strings as properties' do
      @c = create_blank_contact
      @c.add(:phone, '867-5309').wont_be_empty

      begin
        @c.add(:name, {value: 'Jenny'})
      rescue RIQ::RIQError
        assert true
      else
        assert false
      end
    end
  end

  describe '#upsert' do 
    it 'should upsert' do
      @sammy = create_sammy
      id = @sammy.id
      @sammy.id = nil
      id.must_equal @sammy.upsert.id

      # could add another assertion with the blank contact
      # though, it's just save
    end
  end
end
