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
require 'transfer_wise/transfer_wise_object'
require 'transfer_wise/api_resource'
require 'transfer_wise/profile'
require 'transfer_wise/quote'
require 'transfer_wise/account'
require 'transfer_wise/transfer'
require 'transfer_wise/util'
require 'transfer_wise/request'
require 'transfer_wise/borderless_account'
require 'transfer_wise/borderless_account/balance_currency'
require 'transfer_wise/borderless_account/statement'
require 'transfer_wise/borderless_account/transaction'

# Errors
require 'transfer_wise/transfer_wise_error'

module TransferWise

  class << self
    attr_accessor :mode
    attr_accessor :access_token

    def api_base
      @api_base ||= mode == 'live' ? 'https://api.transferwise.com' : 'https://api.sandbox.transferwise.tech'
    end
  end
end
