module TransferWise
  class Request

    def self.api_url(url = '')
      TransferWise.api_base + url
    end

    def self.request(method, url, params={}, headers={})
      url = api_url(url)
      access_token = headers.delete(:access_token)
      request_opts = {
        url: url,
        method: method,
        payload: params.to_json,
        headers: request_headers(access_token).update(headers)
      }
      response = execute_request(request_opts)
      parse(response)
    end

    private

    def self.request_headers(access_token)
      {
        'Authorization' => "Bearer #{access_token}",
        'Content-Type' => 'application/json'
      }
    end

    def self.execute_request(request_opts)
      begin
        response = RestClient::Request.execute(request_opts)
      rescue => e
        if e.is_a?(RestClient::Exception)
          response = handle_error(e, request_opts)
        else
          raise
        end
      end
      response
    end

    def self.parse(response)
      begin
        response = JSON.parse(response.body)
      rescue JSON::ParserError
        raise handle_parse_error(response.code, response.body)
      end
      Util.indifferent_access(response)
    end

    def self.handle_error(e, request_opts)
      if e.is_a?(RestClient::ExceptionWithResponse) && e.response
        handle_api_error(e.response)
      else
        handle_restclient_error(e, request_opts)
      end
    end

    def self.handle_api_error(resp)
      error_obj = parse(resp)
      error = error_obj[:error]
      if TransferWise::STATUS_CLASS_MAPPING.include?(resp.code)
        raise "TransferWise::#{TransferWise::STATUS_CLASS_MAPPING[resp.code]}".constantize.new(error_params(error, resp, error_obj))
      else
        raise TransferWise::TransferWiseError.new(error_params(error, resp, error_obj))
      end
    end

    def self.handle_restclient_error(e, request_opts)
      connection_message = "Please check your internet connection and try again. "

      case e
      when RestClient::RequestTimeout
        message = "Could not connect to TransferWise (#{request_opts[:url]}). #{connection_message}"
      when RestClient::ServerBrokeConnection
        message = "The connection to the server (#{request_opts[:url]}) broke before the " \
          "request completed. #{connection_message}"
      else
        message = "Unexpected error communicating with TransferWise. "
      end

      raise TransferWise::APIConnectionError.new({message: "#{message} \n\n (Error: #{e.message})"})
    end

    def self.handle_parse_error(rcode, rbody)
      TransferWise::ParseError.new({
        message: "Not able to parse because of invalid response object from API: #{rbody.inspect} (HTTP response code was #{rcode})",
        http_status: rcode,
        http_body: rbody
      })
    end

    def self.error_params(error, resp, error_obj)
      {
        message: error,
        http_status: resp.code,
        http_body: resp.body,
        json_body: error_obj,
        http_headers: resp.headers
      }
    end

  end
end