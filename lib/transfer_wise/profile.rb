module TransferWise
  class Profile < APIResource

    def self.list(filters = {}, headers = {})
      response = TransferWise::Request.request(:get, resource_url, filters, headers)
      convert_to_transfer_wise_object(response)
    end
  end
end