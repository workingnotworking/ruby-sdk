require_relative 'test_helper'

describe RIQ::BatchManager do
  before do
    @c = 0
  end

  describe '#accounts' do
    it 'should get all accounts' do
      # could limit this, but want it to make sure the default works
      accounts = RIQ.accounts
      accounts.each do |a|
        a.id.wont_be_nil
        a.name.wont_be_nil
        @c += 1
        break if @c >= 5
      end
      @c.wont_equal 0
    end
  end

  describe '#contacts' do 
    it 'should get all contacts' do
      contacts = RIQ.contacts({_limit: 3})
      contacts.each do |con|
        con.id.wont_be_nil
        @c += 1
        # need to test that it can cycle to the next call
        break if @c >= 10
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
          break if lic >= 3
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

    it 'should not change fetch options' do
      opts = {_limit: 15, _ids: '5550fd35e4b0da744884f69d'}
      bm = RIQ.contacts(opts)
      bm.first
      bm.fetch_options.must_equal bm.fetch_options.merge(opts)
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
