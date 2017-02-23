module TransferWise
  class APIResource

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
      TransferWise::Request.request(:post, resource_url, params, opts)
    end

  end
end
