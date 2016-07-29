require_relative 'test_helper'

describe SIQ::AccountProperties do
  before do
    @p = SIQ.account_props
  end

  describe '#initialize' do
    it 'should have data' do 
      @p.data.wont_be_nil
    end
  end 

  describe '#field' do
    it 'should return a value if appropreate' do
      @p.field('address').wont_be_nil
      @p.field('blah').must_be_nil
    end
  end
end
