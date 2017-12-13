module TransferWise
  class BorderlessAccount::BalanceCurrency < APIResource
    def self.collection_url(resource_id = nil)
      "/#{API_VERSION}/borderless-accounts/balance-currencies"
    end
  end
end
