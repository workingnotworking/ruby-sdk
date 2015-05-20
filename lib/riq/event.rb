require_relative 'riq_obj'
using RIQExtensions

module RIQ
  # Events represent interactions involving a Contact associated with a List Item. 
  class Event < RIQObject
    attr_accessor :subject
    attr_accessor :body
    # attr_reader :participant_ids

    # (see RIQObject#node)
    def node
      self.class.node
    end

    # (see RIQObject#node)
    def self.node
      "events"
    end
    
    # (see RIQObject#data)
    def data
      {
        subject: @subject,
        body: @body,
        participant_ids: @participant_ids
      }
    end

    # @param type [Symbol] One of :email or :phone
    # @param value [String] An email or phone number for the contact
    def add_participant(type, value)
      raise RIQError, 'Type must be :email or :phone' unless [:email, :phone].include?(type)
      @participant_ids << {type: type, value: value}
    end

    # @return [Array] Immutable copy of participant_ids
    def participant_ids
      @participant_ids.dup
    end

    # @return [Hash] Success message, if successful. 
    def save
      # there are no options to pass for event save
      @client.put(node, payload, options: nil)
      {status: 204, message: 'No Content'}
    end

    private
    def init(obj = nil)
      unless obj.nil?
        @subject = obj[:subject]
        @body = obj[:body]
        @participant_ids = []
        obj[:participant_ids].each{|o| add_participant(o[:type], o[:value])}
      else
        @subject = nil
        @body = nil
        @participant_ids = []
      end
      self
    end
  end

  class << self
    # Convenience method to create new Events
    # @param obj [Hash] Info to parse into event
    # @return [Event]
    def event(obj = nil)
      Event.new(obj)
    end
  end
end