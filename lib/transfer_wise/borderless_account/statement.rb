module TransferWise
  class BorderlessAccount::Statement < APIResource
    def self.collection_url(resource_id = nil)
      "/#{API_VERSION}/borderless-accounts/statement"
    end
  end
end
