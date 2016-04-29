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

In its current state, the strategy can recieve an access token from Braintree, but is unable to parse the response.  Braintree serializes access token as XML under the root `credentials`, which I am finding to be very problematic, as OAuth2 seems to be unable to parse the response. I'm still searching for the correct collection of options to pass to the superclasses to make the parsing of the response work.  It's very close!
