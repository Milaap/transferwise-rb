# TransferWise

Welcome to transfer_wise ruby gem! The transfer_wise Ruby gem provide a small SDK for convenient access to the TransferWise API from applications written in the Ruby language. It provides a pre-defined set of classes for API resources that initialize themselves dynamically from API responses which allows the bindings to tolerate a number of different versions of the API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'transfer_wise'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install transfer_wise

## Usage

The library needs to be configured with environment mode "test" or "live"
```ruby
For live mode
TransferWise.mode = "live"

For test mode
TransferWise.mode = "test"
```
# Development
## Authentication

TransferWise uses OAuth 2 for API authentication and authorization. Calls done in behalf of the user require the access token, other calls require Basic Auth. Please keep in mind that tokens are unique to user and should be stored securely.

```ruby
tw = TransferWise::OAuth.new(client_id, client_secret)
```

```ruby
redirect_url = "www.example.com/callback" # Url where you want user to redirect back after authentication from transferwise
url = tw.authorize_url(redirect_url)
```

This will give you the url where you have to redirect the user to authorize and after authorization you will get redirected to redirect_url with  authentication_code.

```ruby
code = "aqw12q" # some authentication_code from response of authentication
tw.get_access_token(code, redirect_url)
=begin
Response:
{
    "token_type" => "bearer",
         "scope" => "transfers",
   :access_token => "1bceb8d8-4115-4daa-8370-d9bc8de0c732",
  :refresh_token => "6ff3451a-e713-416a-b735-20d8020f6ce2",
     :expires_at => 1487908739
}
=end
```

Store this access token and periodically refresh it before it expires

```ruby
tw.refresh_token(access_token, opts = {refresh_token: refresh_token, expires_at: expires_at})
=begin
Response:
{
  "token_type" => "bearer",
       "scope" => "transfers",
 :access_token => "59e18a25-c84e-4f06-aee4-416c9211a8c8",
:refresh_token => "6ff3451a-e713-416a-b735-20d8020f6ce2",
   :expires_at => 1487873072
}
=end
```

# Anatomy of a TransferWise Transfer
To create the transfers, we need to get profile, quote and target account first.

## Profile
Create a profile as individual or business.
```ruby
profile_request = {
  type: "personal", # or business
  details: {
      firstName: "First name",       # Sender FirstName
      lastName: "Last Name",         # Sender LastName
      dateOfBirth: "1980-07-20",     # sender DOB
      phoneNumber: "+918147001602"   # Sender number in international format
  }
}
profile = TransferWise::Profile.create(profile_request, {access_token: access_token})
```
## Quote
Create a quote
```ruby
quote_request = {
  profile: profile.id,  # got from previous profile response
  source: "USD",        # source currency
  target: "INR",        # target currency
  sourceAmount: "100",  # source amount is amount which sender is going to send. TransferWise will deduct their fees and receipient will receive less money.
  rateType: "FIXED"
}
quote = TransferWise::Quote.create(quote_request, {access_token: access_token})
```
## Account

Next step is to create the account where you want to transfer the money.
If you already have the account you can use that account id and skip this account creation part.

```ruby
account_request = {
  "profile" => profile.id,
  "accountHolderName" => "Account Holder Name",
  "currency" => "INR",     # target currency name
  "country" => "IN",       # target country code
  "type" => "",            # get from account requirements
  "details" => {
      "legalType" => "PRIVATE",
      "accountNumber" => "",     # target account number
      "ifscCode" => "",          # ifsc code or any other field. Get field name finformation from account requirements api. This could be different for other country except india.
      "address" => {             # get address details also from account requirement based on country.
        "city" => "City name",   # city name
        "country" => "IN",       # country code
        "firstLine" => "",       # address first line
        "postCode" => ""         # post code
      }
  }
}
account = TransferWise::Account.create(account_request, {access_token: access_token})
```

## Transfer

Create a transfer
```ruby
transfer_request = {
  "targetAccount" => account.id,
  "quote" => quote.id,
  "details" => {
    "reference" => "Any Comment" # get the field detail, from transfer requirements api before creating the transfer object.
  }
}
transfer = TransferWise::Transfer.create(transfer_request, {access_token: access_token})

```

Transfer object is created in transfer wise website. You can go there and make payments to complete the transfer.
