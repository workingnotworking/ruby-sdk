require_relative 'test_helper'

def create_netflix
  SIQ.account('579bb41fe4b01648f2d7e7a9')
end

def create_blank_account
  SIQ.account
end

def create_data_account
  SIQ.account({name: 'Glengarry', field_values: {'0' => 3}})
end

describe SIQ::Account do
  describe '#new' do
    it 'should get account' do
      @netflix = create_netflix
      @netflix.name.must_equal 'Netflix'
    end

    it 'should make blank account' do
      @a = create_blank_account
      @a.wont_be_nil
    end

    it 'should take a data hash' do 
      @dat = create_data_account
      @dat.name.wont_be_nil
    end
  end

  describe '#save' do 
    it 'should create new account' do
      @a = create_blank_account
      @a.name = 'Delete Test Inc'
      @a.field_value(2, '1')
      @a.save

      @a.id.wont_be_nil
    end

    it 'should create new account populating all fields values' do
      contact = SIQ.contact('579bb1d3e4b0cb31c3328e56')

      @a = create_blank_account
      @a.name = 'Delete Test Inc (all values)'

      @a.field_value('address', 'New York, NY, USA')
      @a.field_value('primary_contact', contact.id)
      @a.field_value('address_city', 'NY')
      @a.field_value('address_state', 'New York')
      @a.field_value('address_postal_code', '95184')
      @a.field_value('address_country', 'United States')

      @a.save

      @a.id.wont_be_nil
      @a.field_values[:address].wont_be_nil
      @a.field_values[:primary_contact].wont_be_nil
      @a.field_values[:address_city].wont_be_nil
      @a.field_values[:address_state].wont_be_nil
      @a.field_values[:address_postal_code].wont_be_nil
      @a.field_values[:address_country].wont_be_nil

    end

  end

  describe "#field_value" do
    it 'should fetch a field value' do 
      @netflix = create_netflix
      @netflix.field_value('address').wont_be_nil
      @dat = create_data_account
      @dat.field_value(0).wont_be_nil
    end
  end
end
