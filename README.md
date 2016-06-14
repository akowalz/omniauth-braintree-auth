# OmniAuth Braintree Auth

An [OmniAuth](https://github.com/intridea/omniauth) strategy for [Braintree Auth](https://www.braintreepayments.com/products-and-features/braintree-auth).

Braintree Auth is currently in closed beta, use the link above to request access.
## Installation

Add it to your application's Gemfile:

```ruby
gem 'omniauth-braintree-auth'
```

And then run:

    $ bundle

## Usage

It's helpful to have a general understanding of how OmniAuth works and what it provides before diving into a particular strategy. I recommend checking out the [OmniAuth documentation](https://github.com/intridead/omniauth) for more information.

The Braintree Auth strategy allows you pass a `client_id`, `client_secret`, `redirect_uri`, `scope`, `environment`, and `landing_page` to as configuration options.  Example usage in a Rack application:

```ruby
use OmniAuth::Builder do
  provider :braintree_auth,
    "your_client_id", "your_client_secret",
    :scope => "read_write",                                                # required
    :redirect_uri => "http://localhost:4567/auth/braintree_auth/callback", # required
    :landing_page => "login"                                               # optional, one of 'signup' or 'login'
    :environment => "production"                                           # optional defaults to sandbox
end
```

or, in Rails:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :braintree_auth,
    "your_client_id", "your_client_secret",
    :scope => "read_write",                                                # required
    :redirect_uri => "http://localhost:4567/auth/braintree_auth/callback", # required
    :landing_page => "login"                                               # optional, one of 'signup' or 'login'
    :environment => "production"                                           # optional defaults to sandbox
end
```

### Environment

The Braintree Auth strategy makes requests against Braintree's sandbox environment by default, which is useful for testing your integration. When you are ready to go live, be sure to specify `environment => "production"` when building your strategy.

### Redirect

To send your users to Braintree, simply point them to `/auth/braintree_auth` in your application.  It's best practice to have your users click the "Connect with Braintree" button provided by Braintree to kick off this redirect.

```
<a href="/auth/braintree_auth">
  <img src="https://s3-us-west-1.amazonaws.com/bt-partner-assets/connect-braintree.png" alt="Connect with Braintree" width="328" height="44">
</a>
```

### Callback

After signing up with Braintree or authorizing access to an existing account, the user will be sent back to your site to the redirect URI you provided.  For OmniAuth, this must be at the path `/auth/braintree_auth/callback`.  Be sure that this URI is whitelisted under your OAuth Application configuration in the Braintree Control Panel (Settings > OAuth Applications).

Once redirected, the Braintree merchant ID, access token, and refresh token will be available in `request.env['omniauth.auth']`

Here is an example auth hash provided in `request.env['omniauth.auth']`:

```ruby
{
  uid: "braintree_merchant_id",
  info: { merchant_id: "braintree_merchant_id" },
  credentials: {
    access_token: "access_token$sandbox$example_access_token"
    refresh_token: "access_token$sandbox$refresh_token"
    expires_at: "2026-06-14 19:49:02 UTC"
  }
}
```

you can then use this information in your application:

```ruby

get '/auth/braintree_auth/callback do
  auth_hash = request.env['omniauth.auth']

  access_token = auth_hash['credentials']['access_token']
end
```

## Example

Here is a full example Sinatra application using `omniauth-braintree-auth`. It simply displays the user's access token after they are redirected.

```ruby
require 'sinatra/base'
require 'omniauth-braintree-auth'

class TestApp < Sinatra::Base
  enable :method_override
  enable :sessions

  use Rack::Session::Cookie

  use OmniAuth::Builder do
    provider :braintree_auth,
      ENV['BRAINTREE_AUTH_CLIENT_ID'], ENV['BRAINTREE_AUTH_CLIENT_SECRET']
      :scope => "read_write",
      :redirect_uri => "http://127.0.0.1:4567/auth/braintree_auth/callback",
      :landing_page => "login",
      :environment => "sandbox",
  end

  get '/' do                                                                                                                                     
    '<a href="/auth/braintree_auth">                                                                                                             
      <img src="https://s3-us-west-1.amazonaws.com/bt-partner-assets/connect-braintree.png" alt="Connect with Braintree" width="328" height="44">
    </a>'                                                                                                                                        
  end                                                                                                                                            
                                                                                                                                                
  get '/auth/braintree_auth/callback' do                                                                                                         
    auth_hash = request.env['omniauth.auth']                                                                                                     
    merchant_id = auth_hash['uid']                                                                                                               
    access_token = auth_hash['credentials']['access_token']                                                                                      
                                                                                                                                                
    "#{access_token} can be used to access merchant #{merchant_id}"                                                                              
  end                                                                                                                                            
end

TestApp.run!
```
