require 'bundler/setup'
require 'faraday_middleware'
require 'omniauth-oauth2'
require 'base64'

module OmniAuth
  module Strategies
    class BraintreeAuth < OmniAuth::Strategies::OAuth2
      option :name, :braintree_auth
      option :raise_errors, false

      option :client_options, {
        :site => "https://api.sandbox.braintreegateway.com:443",
        :authorize_url => "/oauth/connect",
        :token_url => "/oauth/access_tokens",
        :raise_errors => false,
      }

      option :authorize_options, [:scope, :redirect_uri]
      option :provider_ignores_state, true

      def request_phase
        base_url = client.auth_code.authorize_url(authorize_params)
        signature = compute_signature(base_url)
        authorize_url = "#{base_url}&signature=#{signature}&algorithm=SHA256"
        redirect authorize_url
      end

      def build_access_token
        options.token_params.merge!(:headers => _authorization_header)
        super
      end

      def _authorization_header
        {"Authorization" => "Basic #{::Base64.strict_encode64("#{options[:client_id]}:#{options[:client_secret]}")}"}
      end

      def compute_signature(url)
        key_digest = OpenSSL::Digest::SHA256.digest(options["client_secret"])
        OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA256.new, key_digest, url)
      end
    end
  end
end
