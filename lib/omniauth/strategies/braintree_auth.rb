require 'omniauth-oauth2'
require 'base64'

module OmniAuth
  module Strategies
    class BraintreeAuth < OmniAuth::Strategies::OAuth2
      option :name, :braintree_auth
      option :environment, "sandbox"

      option :client_options, {
        :authorize_url => "/oauth/connect",
        :site => "https://api.sandbox.braintreegateway.com",
        :token_url => "/oauth/access_tokens",
        :raise_errors => false,
      }

      option :authorize_options, [:scope, :redirect_uri, :landing_page]

      credentials do
        access_token.params["credentials"]
      end

      uid do
        request.params["merchantId"]
      end

      info do
        {"merchant_id" => request.params["merchantId"]}
      end

      def setup_phase
        options.raise_errors = false
        options.client_options.site = "https://api.braintreegateway.com" if options.environment == "production"

        # application/xml content type is not recognized as XML by OAuth2 gem, so we must register it manually
        # https://github.com/intridea/oauth2/pull/255 would add it as a registered content type
        ::OAuth2::Response.register_parser(:xml, "application/xml") { |body| MultiXml.parse(body) }
      end

      def request_phase
        # Braintree requires a custom signature for authorization requests
        base_url = client.auth_code.authorize_url(authorize_params)
        signature = compute_signature(base_url)
        authorize_url = "#{base_url}&signature=#{signature}&algorithm=SHA256"
        redirect authorize_url
      end

      def build_access_token
        options.token_params.merge!(:headers => authorization_header)
        super
      end

      private

      def authorization_header
        {"Authorization" => "Basic #{::Base64.strict_encode64("#{options[:client_id]}:#{options[:client_secret]}")}"}
      end

      def compute_signature(url)
        key_digest = OpenSSL::Digest::SHA256.digest(options["client_secret"])
        OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA256.new, key_digest, url)
      end
    end
  end
end
