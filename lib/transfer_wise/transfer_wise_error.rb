module TransferWise

  STATUS_CLASS_MAPPING = {
    400 => "InvalidRequestError",
    404 => "InvalidRequestError",
    401 => "AuthenticationError"
  }

  class TransferWiseError < StandardError
    attr_reader :message, :http_status, :http_body, :http_headers, :json_body

    def initialize(params = {})
      params.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def to_s
      status_string = @http_status.nil? ? "" : "(Status #{@http_status}) "
      "#{status_string}#{@message}"
    end
  end

  class APIConnectionError < TransferWiseError
  end

  class APIError < TransferWiseError
  end

  class AuthenticationError < TransferWiseError
  end

  class InvalidRequestError < TransferWiseError
  end

  class ParseError < TransferWiseError
  end

end
