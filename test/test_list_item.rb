require_relative 'test_helper'

def create_blank_list_item
  @l.list_item
end

def create_first
  @l.list_items.first
end

describe SIQ::ListItem do
  before do
    lid = '578e5fbfe4b0572044e217ae'
    @l = SIQ.list(lid)
  end

  describe '#field_value' do
    it 'should return a value' do
      @li = create_first
      @li.field_value(0).wont_be_nil

      @blank = create_blank_list_item
      @blank.field_value(0).must_be_nil
    end
  end

  describe '#save' do
    it 'should create and delete' do
      @blank = create_blank_list_item
      @blank.field_value(0, 1)
      @blank.contact_ids << SIQ.contacts.first.id
      @blank.save
      @blank.id.wont_be_nil

      assert @blank.delete
    end

    it 'should update' do
      @li = create_first
      start = @li.field_value(0)
      # tests are recorded, not sure if we need the switcher
      if start == '1'
        @li.field_value(0, 0)
      else
        @li.field_value(0, 1)
      end
      @li.save

      @li.field_value(0).wont_equal start
    end

    it 'should handle picklists' do
      @li = create_first
      start = @li.field_value(10).dup
      # tests are recorded, not sure if we need the switcher
      if start.size == 2
        # dup so we can add without affecting initial value
        @li.field_value(10, start.dup << 1)
      else
        @li.field_value(10).pop
      end
      @li.save

      @li.field_value(10).size.wont_equal start.size
    end

    it 'should fail without a list id' do
      @li = SIQ::ListItem.new
      begin
        @li.save
      rescue SIQ::SIQError
        assert true
      else
        assert false
      end
    end
  end

  describe '#upsert' do

    it 'should upsert contact' do
      first_contact = SIQ.contacts.first

      @blank = create_blank_list_item
      @blank.contact_ids << first_contact.id.to_s # '578fcc6ae4b0cb3178c84e16'
      @blank.field_value(0,1)
      upsert_obj = @blank.upsert('contact_ids')
      first_contact.id.must_equal upsert_obj.contact_ids[0]

    end

    it 'should upsert account' do
      fist_account = SIQ.accounts.first

      lid = '578e5fbfe4b0572044e217ae'
      @list_account = SIQ.list(lid)
      @blank_list_item = @list_account.list_item

      @blank_list_item.account_id = fist_account.id.to_s
      @blank_list_item.name = "New Name from Ruby"
      @blank_list_item.field_value(0,2)
      upsert_obj = @blank_list_item.upsert('account_id')
      fist_account.id.must_equal upsert_obj.account_id
    end
  end
end
