require_relative 'riq_obj'

module RIQ
  # Users are represented by owners and contacts in your RelateIQ organization
  class User < RIQObject
    attr_accessor :name
    attr_accessor :email

    # (see RIQObject#node)
    def node
      "users/#{@id}"
    end

    # (see RIQObject#data)
    def data
      {
        id: @id,
        name: @name,
        email: @email
      }
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
      RIQ::User.new(id)
    end
  end
end