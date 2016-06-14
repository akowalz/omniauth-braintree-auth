require 'spec_helper'

describe OmniAuth::BraintreeAuth do
  def app
    lambda { |_| [200, {}, ["Hello."]] }
  end

  let(:client_id) { "client_id" }
  let(:client_secret) { "client_secret" }
  let(:options) { Hash.new }
  let(:strategy) { OmniAuth::Strategies::BraintreeAuth.new(app, client_id, client_secret, options) }

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
    expect( strategy.name ).to eq(:braintree_auth)
  end

  describe "client options" do
    it "allows configurable client_id and client_secret" do
      expect( strategy.options["client_id"] ).to eq("client_id")
      expect( strategy.options["client_secret"] ).to eq("client_secret")
    end

    it "has correct authorize and token URLs" do
      expect( strategy.options.client_options.authorize_url ).to eq("/oauth/connect")
      expect( strategy.options.client_options.token_url ).to eq("/oauth/access_tokens")
    end
  end

  describe "setup_phase" do
    describe "host configuration" do
      let(:options) { {:environment => "sandbox"} }

      context "environment set to sandbox" do
        it "uses sandbox.braintreegateway.com" do
          strategy.setup_phase

          expect( strategy.options.client_options.site ).to eq("https://api.sandbox.braintreegateway.com")
        end
      end

      context "environment set to production" do
      let(:options) { {:environment => "production"} }
        it "uses braintreegateway.com" do
          strategy.setup_phase

          expect( strategy.options.client_options.site ).to eq("https://api.braintreegateway.com")
        end
      end

      context "when no environment is specified" do
      let(:options) { {:environment => "sandbox"} }
        it "defaults to the sandbox endpoint" do
          strategy.setup_phase

          expect( strategy.options.client_options.site ).to eq("https://api.sandbox.braintreegateway.com")
        end
      end
    end
  end

  describe "authorize options" do
    let(:options) do
      {
        :scope => "read_only",
        :redirect_uri => "https://example.com/callback",
        :landing_page => "login",
        :environment => "sandbox",
      }
    end

    it "allows configurable authorize options" do
      expect( strategy.authorize_params.scope ).to eq("read_only")
      expect( strategy.authorize_params.redirect_uri ).to eq("https://example.com/callback")
      expect( strategy.authorize_params.landing_page ).to eq("login")
    end
  end
end
