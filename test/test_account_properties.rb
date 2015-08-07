require_relative 'test_helper'

describe RIQ::AccountProperties do
  before do
    @p = RIQ.account_props
  end

  describe '#initialize' do
    @p.data.wont_be_nil
  end 

  describe '#field' do
    it 'should return a value if appropreate' do
      @p.field(2).wont_be_nil
      @p.field('blah').must_be_nil
    end
  end
end
