module TransferWise
  class BorderlessAccount < APIResource
    def self.collection_url(resource_id = nil)
      "/#{API_VERSION}/borderless-accounts"
    end
  end
end
