using SIQExtensions

module SIQ
  # Simple object for retrieving your org-wide account properties. The object is read only and provides only fetch and convenience methods.
  class AccountProperties
    attr_reader :data

    # Performs a network call and fetches the account properties for the org.
    def initialize
      @client = SIQ.client
      d = @client.get(node).symbolize
      if d
        @data = d[:fields]
      else
        raise SIQError, 'No account properties found'
      end
    end

    # (see SIQObject#node)
    def node
      'accounts/fields'
    end

    # @param id [String, Int] A simple lookup for a field that has a matching ID
    def field(id)
      @data.select{|f| f[:id] == id.to_s}.first
    end
  end

  class << self
    def account_props
      AccountProperties.new
    end
  end
end