module RIQ
  # Base exception class for our errors.
  class RIQError < StandardError
  end

  # Hasn't been implemented yet. Doesn't get used often.
  class NotImplementedError < RIQError
  end

  # Raised when an ObjectId fetch doesn't return anything.
  class NotFoundError < RIQError
  end

  # Main error that includes info about the request and what went wrong. 
  class HTTPError < RIQError
    attr_accessor :code
    attr_accessor :message
    attr_accessor :response

    def initialize(resp)
      # build response message
      message = "\n[#{resp.code}] #{resp.message} : "        
      unless resp.parsed_response.nil?
        begin
          m = resp.parsed_response.fetch('errorMessage', 'no message')
        rescue
          # parse returned HTML
          reg = resp.parsed_response.match(/<pre>(.*)<\/pre>/)
          unless reg.nil?
            m = reg[1].strip
          else
            m = 'no message'
          end
        end
        message += "<#{m}>"
      end

      # pull out request info
      req = resp.request
      unless req.nil?
        message += "\n    Request: #{req.http_method} #{req.last_uri.to_s}"
        unless req.raw_body.nil?
          message += "\n    #{req.raw_body}"
        end
      end

      @message = message
      @response = resp
    end

    # used to print the error nicely
    def to_s
      @message || super
    end
  end
end
