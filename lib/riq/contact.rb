require_relative 'riq_obj'
using RIQExtensions

module RIQ
  # Contacts represent people in an Organization’s address book.
  class Contact < RIQObject
    attr_accessor :properties

    # (see RIQObject#node)
    def node
      self.class.node(@id)
    end

    # (see RIQObject.node)
    def self.node(id = nil)
      "contacts/#{id}"
    end
    
    # (see RIQObject#data)
    def data
      {
        id: @id,
        properties: @properties
        # modified_date: @modified_date
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

      raise RIQError, 'Values must be strings' unless val.is_a?(String)

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
    # @see RIQObject#save
    def upsert
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
        obj[:properties].each do |k,v|
          raise RIQError, "Properties must be arrays, #{k} wasn't" unless v.is_a?(Array)

          v.each do |i|
            unless i.is_a?(Hash)
              add(k, i)
            else
              @properties[k] = [] unless @properties.include?(k)
              @properties[k] << i
            end
          end
        end
      else
        @id = nil
        @properties = {}
      end
      self
    end

    # unused because we actually put all sorts of stuff in there
    def validate(prop)
      raise RIQError, %q(Invalid property. Use [:name | :phone | :email | :address] instead) unless [:name, :phone, :email, :address].include?(prop)
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
          [[(metadata || {})[:primary] == 'true' ? 0 : 1, (metadata || {})[:inactive] == 'true' ? 1 : 0], p[:value]]
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
