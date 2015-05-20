require_relative 'riq_obj'
using RIQExtensions

module RIQ
  # Accounts represent companies (or other entities).
  class Account < RIQObject
    attr_accessor :name
    attr_accessor :field_values

    # (see RIQObject#node)
    def node
      "accounts/#{@id}"
    end

    # (see #node)
    def self.node(arg = nil)
      "accounts"
    end

    # (see RIQObject#data)
    def data
      {
        id: @id,
        name: @name,
        field_values: @field_values
      }
    end

    # (see RIQObject#payload)
    def payload
      # TODO: find more elegant way to do this
      pld = data
      pld['fieldValues'] = @field_values.to_raw
      pld.delete(:field_values)
      pld.to_json
    end

    # @overload field_value(key)
    #   @param key [String, Integer] 
    #   @return [Array] Value of key
    # @overload field_value(key, value)
    #   Sets key to value
    #   @param key [String, Integer] Key to set
    #   @param value [#to_s] Sets key to value
    def field_value(key, value = nil)
      # TODO: double check that this works with arrays of stuff
      # or, have a format function that casts ints to string on save
      if value.nil?
        @field_values.fetch(key.to_sym, nil)
      else
        @field_values[key.to_sym] = value.to_s
        {key.to_sym => value.to_s}
      end
    end

    private
    def init(obj = nil)
      unless obj.nil?
        @id = obj[:id]
        @name = obj[:name]
        @field_values = obj[:field_values] ? obj[:field_values].from_raw : {}
        @modified_date = obj[:modified_date].cut_milis if obj[:modified_date]
      else
        @id = nil
        @name = nil
        @field_values = {}
      end
      self
    end

  end

  class << self
    # Convenience method to create new Accounts
    # @param id [String, nil] create a blank Account object or 
    #   fetch an existing one by id.
    # @return [Account]
    def account(id = nil)
      Account.new(id)
    end
  end
end