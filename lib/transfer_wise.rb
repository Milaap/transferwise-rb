# TransferWise Ruby bindings
require 'open-uri'
require 'oauth2'
require 'rest-client'
require 'json'

# Version
require "transfer_wise/version"

# Oauth2 Authentication
require "transfer_wise/oauth"

# Resources
require 'transfer_wise/api_resource'
require 'transfer_wise/quote'
require 'transfer_wise/account'
require 'transfer_wise/transfer'
require 'transfer_wise/util'
require 'transfer_wise/request'

# Errors
require 'transfer_wise/errors/transfer_wise_error'
require 'transfer_wise/errors/api_error'

module TransferWise

  @api_base = "https://#{Rails.env.production? ? 'api' : 'test-restgw'}.transferwise.com"

  class << self
    attr_accessor :api_base
  end

end