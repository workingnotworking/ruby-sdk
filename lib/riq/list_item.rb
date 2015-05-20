require_relative 'riq_obj'
using RIQExtensions

module RIQ
  # A List Item is a row in a List.
  class ListItem < RIQObject
    attr_accessor :name
    attr_accessor :field_values
    attr_accessor :account_id
    attr_accessor :contact_ids
    attr_accessor :list_id

    attr_reader :modified_date
    attr_reader :created_date

    def initialize(id = nil, lid: nil)
      if id.is_a? Hash
        super(id)
      elsif id.nil? && lid.nil?
        super(nil)
      elsif id.nil? && !lid.nil?
        super(nil)
        @list_id = lid
      elsif id.nil? || lid.nil?
        raise RIQError, 'ObjectID and List ID are required'
      else
        super("#{lid}/listitems/#{id}")
      end
    end

    # (see RIQObject#node)
    def node
      self.class.node(@list_id, @id)
    end

    # @note this is the only object for which you have to include two params
    # @param lid [String] ListId that the lit item belongs to
    # @param oid [String] ObjectId for the object
    def self.node(lid = nil, oid = nil)
      # weird workaround for fetching node on init
      if lid.nil? && !oid.nil?
        "lists/#{oid}"
      else  
        "lists/#{lid || @list_id}/listitems/#{oid}"
      end
    end

    # (see RIQObject#data)
    def data
      {
        name: @name,
        account_id: @account_id,
        contact_ids: @contact_ids.flatten,
        id: @id,
        list_id: @list_id,
        field_values: @field_values,
        modified_date: @modified_date
      }
    end

    # (see RIQObject#payload)
    def payload
      pld = {}
      data.each do |k, v|
        if k == :field_values
          pld['fieldValues'] = @field_values.to_raw
        elsif k['_']
          pld[k.to_cam] = v
        else
          pld[k] = v
        end
      end
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
        @list_id = obj[:list_id]
        @name = obj[:name]
        @field_values = obj[:field_values] ? obj[:field_values].from_raw : {}
        @account_id = obj[:account_id]
        @contact_ids = obj[:contact_ids] || []
        @modified_date = obj[:modified_date].cut_milis if obj[:modified_date]
        @created_date = obj[:creaeted_date].cut_milis if obj[:creaeted_date]
      else
        @id = nil
        @list_id = nil
        @name = nil
        @field_values = {}
        @account_id = nil
        @contact_ids = []
        @modified_date = nil
        @created_date = nil
      end
      self
    end
  end
end