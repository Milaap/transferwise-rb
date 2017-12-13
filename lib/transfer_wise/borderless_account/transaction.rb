module TransferWise
  class BorderlessAccount::Transaction < APIResource
    def self.collection_url(resource_id = nil)
      "/#{API_VERSION}/borderless-accounts/#{resource_id}/transactions"
    end
  end
end
