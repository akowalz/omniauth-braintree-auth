# OmniAuth Braintree Auth

**NOTICE: Work in progress. Currently cannot complete full OAuth flow**

An [OmniAuth](https://github.com/intridea/omniauth) strategy for [Braintree Auth](https://www.braintreepayments.com/products-and-features/braintree-auth). 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-braintree-auth'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-braintree-auth

## Usage

The Braintree Auth strategy requires you pass a `client_id`, `client_secret`, `redirect_uri`, and `scope` to build the strategy.  Example usage:

```ruby
use OmniAuth::Builder do
  provider :braintree_auth,
    "client_id$sandbox$4jfjn846stp6nvyn", "client_secret$sandbox$f0c5bacce3ba241c5e88a220b740966b",
    :scope => "read_write",
    :redirect_uri => "http://localhost:4567/auth/braintree_auth/callback"
end
```

See [OmniAuth's README](https://github.com/intridea/omniauth) for detailed instructions on how to use OmniAuth strategies.

When it's working, it will provide the Braintree User ID, access token, and refresh tokens of the authorized user in the omniauth auth hash.

## What needs fixing

I've been able to get through the request phase and the first part of the OAuth callback phase.  The gem is able to succesfully recieve and auth code and Braintree User ID from Braintree, but currently fails at the next stage of the OAuth flow, where the auth code is exchanged for an access token. Something is wrong with the request, because I am recieving the error from Braintree `"Invalid credentials: wrong client id or secret"` when trying to make this request. The entire callback phase is inherited from the [OmniAuth OAuth2 gem](https://github.com/intridea/omniauth-oauth2/), so perhaps something about Braintree's API is not standard and these credentials need to be passed differently.

I'll keep working at this, but if you figure out what the problem is, please let me know!
