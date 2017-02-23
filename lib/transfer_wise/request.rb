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

    def self.execute_request(opts)
      RestClient::Request.execute(opts)
    end

    def self.parse(response)
      response = JSON.parse(response.body)
      Util.indifferent_access(response)
    end

  end
end