module TransferWise
  class TransferWiseError < StandardError
    attr_reader :message
    attr_reader :http_status
    attr_reader :http_body
    attr_reader :http_headers
    attr_reader :request_id
    attr_reader :json_body

    def initialize(params)
      @message = params[:message]
      @http_status = params[:http_status]
      @http_body = params[:http_body]
      @http_headers = params[:http_headers] || {}
      @json_body = params[:json_body]
      @request_id = @http_headers[:request_id]
    end

    def to_s
      status_string = @http_status.nil? ? "" : "(Status #{@http_status}) "
      id_string     = @request_id.nil? ? "" : "(Request #{@request_id}) "
      "#{status_string}#{id_string}#{@message}"
    end
  end
end
