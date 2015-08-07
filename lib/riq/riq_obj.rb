require_relative 'client'
using RIQExtensions

module RIQ
  # @abstract This class should not be used directly. 
  #   Instead, use a child such as {Contact} or {List}.
  class RIQObject
    attr_accessor :id
    attr_reader :modified_date

    # @param id [String, Hash] ObjectId or well-formatted hash of data (usually provided by another object
    # @return [RIQObject] Self
    def initialize(id = nil)
      @client = RIQ.client
      @id = id

      unless @id.nil?
        # data hash
        if @id.is_a? Hash
          # this looks dumb, could name variables better
          data = @id
        else
          data = @client.get(node)
        end
        init(data.symbolize)
      else
        init
      end
      self
    end

    # @return [String] endpoint
    def node
      raise RIQError, 'This should be overwritten'
    end

    # @param id [String] ObjectId
    # @return [String] endpoint
    def self.node(id = nil)
      raise RIQError, 'This should be overwritten'
    end    

    # @return [Hash] all relevant stored data
    def data
      raise RIQError, 'This should be overwritten'
    end
    
    # @return [String] the JSON representation of {#data}
    def payload
      pld = {}
      data.each do |k, v|
        if k['_']
          pld[k.to_cam] = v
        else
          pld[k] = v
        end
      end
      pld.to_json
    end

    # Creates or updates the object
    def save(options = nil)
      if @id.nil?
        # create
        init(@client.post(node, payload, options: options).symbolize)
      else
        # update
        init(@client.put(node, payload, options: options).symbolize)
      end
    end

    # Deletes the object
    # @note This is IRREVERSIBLE
    def delete
      @client.delete(node)
    end

    # can't decide how I want objects displayed
    # when you print the object
    # def to_s
      # JSON.pretty_generate(data)
      # data
    # end

    # When the object itself is called or returned
    # def inspect
      # data
    # end

    private
    def init
      raise RIQError, 'This should be overwritten'
    end

    # def exists
    #   if @id.nil?
    #     false
    #   else
    #     @client.fetch(node)
    #   end
    # end
  end
end