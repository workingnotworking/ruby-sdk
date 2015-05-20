require 'minitest/autorun'
require_relative '../lib/riq'

describe RIQ::BatchManager do
  before do
    RIQ.init
    @c = 0
  end

  describe '#accounts' do
    it 'should get all accounts' do
      accounts = RIQ.accounts
      accounts.each do |a|
        a.id.wont_be_nil
        a.name.wont_be_nil
        @c += 1
        break if @c >= 20
      end
      @c.wont_equal 0
    end
  end

  describe '#contacts' do 
    it 'should get all contacts' do
      contacts = RIQ.contacts
      contacts.each do |con|
        con.id.wont_be_nil
        @c += 1
        break if @c >= 20
      end
      @c.wont_equal 0
    end
  end

  describe '#lists' do
    it 'should get all lists' do
      lists = RIQ.lists
      lists.each do |l|
        l.id.wont_be_nil
        l.title.wont_be_nil
        l.fields.wont_be_nil
        @c += 1
        lic = 0
        l.list_items.each do |li|
          lic += 1
          break if lic >= 5
        end
        lic.wont_equal 0
        break if @c >= 20
      end
      @c.wont_equal 0
    end
  end

  describe '#first' do 
    it 'should get one contact' do
      c = nil
      c = RIQ.contacts.first
      c.must_be_instance_of RIQ::Contact
    end
  end

  describe '#fetch_options' do 
    it 'should respect limits' do 
      b = RIQ.contacts({_ids: ['53a0bc44e4b0d7993870bcf4','5550fd35e4b0da744884f69d']})
      b.each do |i|
        @c += 1
      end
      @c.must_equal 2
    end
  end
end