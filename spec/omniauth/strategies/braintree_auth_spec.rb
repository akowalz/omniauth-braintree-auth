require 'spec_helper'

describe OmniAuth::BraintreeAuth do
  def app
    lambda { |_| [200, {}, ["Hello."]] }
  end

  before do
    OmniAuth.config.test_mode = true
  end

  after do
    OmniAuth.config.test_mode = false
  end

  it 'has a version number' do
    expect(OmniAuth::BraintreeAuth::VERSION).not_to be nil
  end

  it "has a name" do
    strategy = OmniAuth::Strategies::BraintreeAuth.new(app)
    expect( strategy.name ).to eq(:braintree_auth)
  end

  describe "client options" do
    it "allows configurable client_id and client_secret" do
      strategy = OmniAuth::Strategies::BraintreeAuth.new(app, "client_id", "client_secret")

      expect( strategy.options["client_id"] ).to eq("client_id")
      expect( strategy.options["client_secret"] ).to eq("client_secret")
    end

    it "has correct authorize and token URLs" do
      strategy = OmniAuth::Strategies::BraintreeAuth.new(app)

      expect( strategy.options.client_options.authorize_url ).to eq("/oauth/connect")
      expect( strategy.options.client_options.token_url ).to eq("/oauth/access_tokens")
    end

    describe "setup_phase" do
      describe "host configuration" do
        it "uses sandbox.braintreegateway.com in sandbox mode" do
          strategy = OmniAuth::Strategies::BraintreeAuth.new(app, "client_id", "client_secret", :environment => "sandbox")
          strategy.setup_phase

          expect( strategy.options.client_options.site ).to eq("https://api.sandbox.braintreegateway.com")
        end

        it "uses braintreegateway.com in sandbox mode" do
          strategy = OmniAuth::Strategies::BraintreeAuth.new(app, "client_id", "client_secret", :environment => "production")
          strategy.request_phase

          expect( strategy.options.client_options.site ).to eq("https://api.braintreegateway.com")
        end

        it "defaults to the production endpoint" do
          strategy = OmniAuth::Strategies::BraintreeAuth.new(app, "client_id", "client_secret")
          strategy.request_phase

          expect( strategy.options.client_options.site ).to eq("https://api.braintreegateway.com")
        end
      end
    end
  end

  describe "authorize options" do
    it "allows configurable authorize options" do
      strategy = OmniAuth::Strategies::BraintreeAuth.new(app, "id", "secret", {
        :scope => "read_only",
        :redirect_uri => "https://example.com/callback",
        :landing_page => "login",
        :environment => "sandbox",
      })

      expect( strategy.authorize_params.scope ).to eq("read_only")
      expect( strategy.authorize_params.redirect_uri ).to eq("https://example.com/callback")
      expect( strategy.authorize_params.landing_page ).to eq("login")
    end
  end
end
