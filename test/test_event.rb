require 'minitest/autorun'
require_relative '../lib/riq'

describe RIQ::Event do
  before do
    RIQ.init
    # sammy's contact ID
    @e = RIQ.event
    @ev = RIQ.event({subject: "My Sub", body: "Bodily harm", 'participantIds' => [{type: :email, value: 'fake@fakerelateiq.com'}]})
  end

  describe '#new' do
    it 'should start blank' do
      @e.subject.must_be_nil
    end

    it 'should take a hash' do
      @ev.subject.wont_be_nil
      @ev.participant_ids.wont_be_empty
    end
  end

  describe '#save' do
    it 'should fail without subject'do
      begin
        @e.save
      rescue RIQ::HTTPError
        nil.must_be_nil
      else
        1.must_be_nil
      end
    end

    it 'should save with data' do 
      @ev.save.must_be_kind_of Hash
    end
  end

  describe '#add_participant' do
    it 'should add a participant' do 
      p = {type: :email, value: 'good'}
      @e.add_participant(p[:type], p[:value])
      @e.participant_ids.must_include p
    end

    it 'should reject bad types' do
      begin
        @e.add_participant(:blarg, 'bad type')
      rescue RIQ::RIQError
        nil.must_be_nil
      else
        1.must_be_nil
      end
    end
  end
end