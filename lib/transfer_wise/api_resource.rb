module TransferWise
  class APIResource
    include TransferWise::TransferWiseObject

    def self.class_name
      self.name.split('::')[-1]
    end

    def self.resource_url
      if self == APIResource
        raise NotImplementedError.new('APIResource is an abstract class. You should perform actions on its subclasses (Account, Transfer, etc.)')
      end
      "/v1/#{CGI.escape(class_name.downcase)}s"
    end

    def self.create(params={}, opts={})
      response = TransferWise::Request.request(:post, resource_url, params, opts)
      convert_to_transfer_wise_object(response)
    end

  end
end
