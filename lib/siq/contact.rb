require_relative 'siq_obj'
using SIQExtensions

module SIQ
  # Contacts represent people in an Organization’s address book.
  class Contact < SIQObject
    attr_accessor :properties
    attr_reader :state
    attr_reader :modified_date

    # (see SIQObject#node)
    def node
      self.class.node(@id)
    end

    # (see SIQObject.node)
    def self.node(id = nil)
      "contacts/#{id}"
    end
    
    # (see SIQObject#data)
    def data
      {
          id: @id,
          #modified_date: @modified_date,
          properties: @properties,
          #state: @state
      }
    end

    # @!macro [new] prop
    #   @return [Array] all of the values for $0
    def name
      get_prop(:name)
    end

    # @!macro [new] prop
    #   @return [String] the preferred value for $0
    def primary_name
      get_primary_prop(:name)
    end

    # @macro prop
    def phone
      get_prop(:phone)
    end

    # @macro prop
    def primary_phone
      get_primary_prop(:phone)
    end

    # @macro prop
    def email
      get_prop(:email)
    end

    # @macro prop
    def primary_email
      get_primary_prop(:email)
    end

    # @macro prop
    def address
      get_prop(:address)
    end

    # @macro prop
    def primary_address
      get_primary_prop(:address)
    end

    # Adds property with correct scaffolding
    # @param prop [Symbol] Type Property to add, such as :name or :email
    # @param val [String, Array] Value(s) to add
    # @return [Array] Values for that property after the add
    def add(prop, val)
      # validate(prop)
      prop = prop.to_sym
      @properties[prop] = [] unless @properties.include? prop

      if val.is_a? Array
        val.each do |i|
          add(prop, i)
        end
        return
      end

      raise SIQError, 'Values must be strings' unless val.is_a?(String)

      # don't add duplicate 
      if @properties[prop].select{|p| p[:value] == val}.empty?
        @properties[prop] << {value: val, metadata: {}}
      end
      get_prop(prop)
    end

    # Removes property from hash
    # @param prop [Symbol] Type Property to remove, such as :name or :email
    # @param val [String, Array] Value(s) to remove
    # @return [Array] Values for that property after the remove
    def remove(prop, val)
      # validate(prop)
      prop = prop.to_sym

      if val.is_a? Array
        val.each do |i|
          remove(prop, i)
        end
      end

      if @properties.include? prop
        @properties[prop] = @properties[prop].reject{|p| p[:value] == val}
      end
      get_prop(prop)
    end

    # Edits an existing object based on matching email(s) or saves a new object
    # @see SIQObject#save
    def upsert
      # can only be email right now
      save({_upsert: 'email'})
    end

    # @param prop [Symbol] The property to fetch. One of [:name, :phone, :email, :address]
    # @param val [String] The value to get info on, such as 'name@domain.com'
    # @return [Hash] metadata and other info about a given property
    def info(prop, val)
      # validate(prop)

      @properties[prop].select{|p| p[:value] == val}.first
    end

    private

    def init(obj = nil)
      unless obj.nil?
        @id = obj[:id]
        @modified_date = obj[:modified_date].cut_milis if obj[:modified_date]
        @properties = {}
        @state = obj[:state] if obj[:state]

        obj[:properties].each do |k, v|
          raise SIQError, "Properties must be arrays, #{k} wasn't" unless v.is_a?(Array)

          v.each do |i|
            if i.is_a?(Hash)
              @properties[k] = [] unless @properties.include?(k)
              @properties[k] << i
            else
              add(k, i)
            end
          end
        end
      else
        @id = nil
        @modified_date = 0
        @properties = {}
        @state = nil
      end
      self
    end

    # unused because we actually put all sorts of stuff in there
    def validate(prop)
      raise SIQError, %q(Invalid property. Use [:name | :phone | :email | :address] instead) unless [:name, :phone, :email, :address].include?(prop)
    end

    def get_prop(prop)
      if @properties.include?(prop)
        @properties[prop].map{|p| p[:value]}
      else
        []
      end
    end

    def get_primary_prop(prop)
      if @properties.include?(prop)
        preferred = @properties[prop].map do |p|
          metadata = (p || {})[:metadata]
          # grades each property, 0 is more likely to be picked
          [
            [
              (metadata || {})[:primary] == 'true' ? 0 : 1, 
              (metadata || {})[:inactive] == 'true' ? 1 : 0
            ],
            p[:value]
          ]
        end
        preferred.sort_by { |p| p[0] }.first[1]
      else
        nil
      end
    end
  end

  class << self
    # Convenience method to create new Contacts
    # @param id [String, nil] create a blank Contact object or 
    #   fetch an existing one by id.
    # @return [Contact]
    def contact(id = nil)
      Contact.new(id)
    end
  end
end
