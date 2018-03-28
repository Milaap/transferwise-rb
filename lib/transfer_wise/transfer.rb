module TransferWise
  class Transfer < APIResource
    def self.fund(resource_id, params, opts = {})
      response = TransferWise::Request.request(:post, "#{resource_url(resource_id)}/payments", params, opts)
      convert_to_transfer_wise_object(response)
    end
  end
end
