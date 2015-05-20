require 'minitest/autorun'
require_relative '../lib/riq'

describe RIQ::ListItem do
  before do
    RIQ.init
    lid = '54ca9b25e4b0b29d80ce4b4e'
    @l = RIQ.list(lid)
    @li = @l.list_items.first
    @blank = @l.list_item
  end

  describe '#field_value' do
    it 'should return a value' do
      @li.field_value(0).wont_be_nil
      @blank.field_value(0).must_be_nil
    end
  end

  describe '#save' do
    it 'should create and delete' do
      @blank.field_value(0, 1)
      @blank.contact_ids << RIQ.contacts.first.id
      @blank.save
      @blank.id.wont_be_nil

      assert(@blank.delete)
    end

    it 'should update' do
      start = @li.field_value(0)
      if start == '1'
        @li.field_value(0, 0)
      else
        @li.field_value(0, 1)
      end
      @li.save

      @li.field_value(0).wont_equal start
    end
  end
end