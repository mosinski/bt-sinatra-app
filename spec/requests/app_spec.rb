require "spec_helper"

RSpec.describe App do
  let(:app) { App.new }
  let(:braintree) { spy("Braintree") }
  let(:response) { double("Response", body: "{}") }

  before do
    allow(Braintree).to receive(:new).and_return(braintree)
  end

  describe "GET /" do
    it "calls `search`" do
      allow(braintree).to receive(:search).and_return(response)
      get "/"
      expect(braintree).to have_received(:search).with(no_args)
    end
  end

  describe "GET /ping" do
    it "calls `ping`" do
      allow(braintree).to receive(:ping).and_return(response)
      get "/ping"
      expect(braintree).to have_received(:ping).with(no_args)
    end
  end

  describe "GET /clientToken" do
    it "calls `createClientToken`" do
      allow(braintree).to receive(:createClientToken).and_return(response)
      get "/clientToken"
      expect(braintree).to have_received(:createClientToken).with(no_args)
    end
  end

  describe "GET /creditCardToken" do
    it "calls `tokenizeCreditCard`" do
      allow(braintree).to receive(:tokenizeCreditCard).and_return(response)
      get "/creditCardToken"
      expect(braintree).to have_received(:tokenizeCreditCard).with(
        "4111 1111 1111 1111", "11/22", "123", "Joe Doe"
      )
    end
  end

  describe "GET /charge/creditcard" do
    it "calls `chargeCreditCard`" do
      allow(braintree).to receive(:chargeCreditCard).and_return(response)
      get "/charge/creditcard"
      expect(braintree).to have_received(:chargeCreditCard).with(
        "fake-valid-visa-nonce", "10.00"
      )
    end
  end

  describe "GET /charge/paypal" do
    it "calls `chargePayPalAccount`" do
      allow(braintree).to receive(:chargePayPalAccount).and_return(response)
      get "/charge/paypal"
      expect(braintree).to have_received(:chargePayPalAccount).with(
        "fake-paypal-one-time-nonce", "10.00"
      )
    end
  end

  describe "GET /charge/venmo" do
    it "calls `chargeVenmoAccount`" do
      allow(braintree).to receive(:chargeVenmoAccount).and_return(response)
      get "/charge/venmo"
      expect(braintree).to have_received(:chargeVenmoAccount).with(
        "fake-venmo-account-nonce", "10.00"
      )
    end
  end

  describe "GET /charge/local" do
    it "calls `chargePaymentMethod`" do
      allow(braintree).to receive(:chargePaymentMethod).and_return(response)
      get "/charge/local"
      expect(braintree).to have_received(:chargePaymentMethod).with(
        "fake-local-payment-method-nonce", "10.00"
      )
    end
  end
end
