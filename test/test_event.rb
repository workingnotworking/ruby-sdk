require_relative 'test_helper'

def create_blank_event
  RIQ.event
end

def create_data_event
  RIQ.event({subject: "My Sub", body: "Bodily harm", 'participantIds' => [{type: :email, value: 'fake@fakerelateiq.com'}]})
end

describe RIQ::Event do
  describe '#new' do
    it 'should start blank' do
      @e = create_blank_event
      @e.subject.must_be_nil
    end

    it 'should take a hash' do
      @ev = create_data_event
      @ev.subject.wont_be_nil
      @ev.participant_ids.wont_be_empty
    end
  end

  describe '#save' do
    it 'should fail without subject' do
      @e = create_blank_event
      begin
        @e.save
      rescue RIQ::HTTPError
        assert true
      else
        assert false
      end
    end

    it 'should save with data' do 
      @ev = create_data_event
      @ev.save.must_be_kind_of Hash
    end
  end

  describe '#add_participant' do
    it 'should add a participant' do 
      @e = create_blank_event
      p = {type: :email, value: 'good'}
      @e.add_participant(p[:type], p[:value])
      @e.participant_ids.must_include p
    end

    it 'should reject bad types' do
      @e = create_blank_event
      begin
        @e.add_participant(:blarg, 'bad type')
      rescue RIQ::RIQError
        assert true
      else
        assert false
      end
    end
  end
end
