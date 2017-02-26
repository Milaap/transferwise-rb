module TransferWise
  module TransferWiseObject

    def self.included(base)
      base.extend ClassMethods
    end

    def initialize()
      @values = {}
    end

    def initialize_from(values)
      add_methods(values.keys)
      update_attributes(values)
      self
    end

    def add_methods(keys)
      self.instance_eval do
        keys.each do |k|
          self.class.send(:define_method, k.underscore) { @values[k] }
        end
      end
    end

    def update_attributes(values)
      values.each do |k, v|
        @values[k] = v
      end
    end

    module ClassMethods
      def convert_to_transfer_wise_object(resp)
        case resp
        when Array
          resp.map { |i| convert_to_transfer_wise_object(i) }
        when Hash
          self.new.initialize_from(resp)
        else
          resp
        end
      end
    end

  end
end