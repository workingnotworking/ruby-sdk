require_relative 'siq_obj'

module SIQ
  # Users are represented by owners and contacts in your SalesforceIQ organization
  class User < SIQObject
    attr_accessor :name
    attr_accessor :email

    # (see SIQObject#node)
    def node
      "users/#{@id}"
    end

    # (see SIQObject#data)
    def data
      {
        id: @id,
        name: @name,
        email: @email
      }
    end

    # Overwriting parent because lists can't be saved through the API
    def save
      raise NotImplementedError, "Users can't be edited through the API"
    end
    
    private
    def init(obj = nil)
      unless obj.nil?
        @id = obj[:id]
        @name = obj[:name]
        @email = obj[:email]
      else
        @id = nil
        @name = nil
        @email = nil
      end
      self
    end
  end

  class << self
    # Convenience method to create new Users
    # @param id [String, nil] create a blank User object or 
    #   fetch an existing one by id.
    # @return [User]
    def user(id = nil)
      SIQ::User.new(id)
    end
  end
end