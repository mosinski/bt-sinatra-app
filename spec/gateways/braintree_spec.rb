require "spec_helper"

RSpec.describe Braintree do
  let(:result) { double(body: {}) }
  let(:body) { JSON.parse(result.body) }

  subject { described_class.new }

  describe "#ping" do
    let(:result) { subject.ping }

    it "is success" do
      VCR.use_cassette("braintree/ping/success") do
        expect(result.success?).to be true
        expect(JSON.parse(result.body).dig("data","ping")).to eq "pong"
      end
    end

    it "is failure" do
      VCR.use_cassette("braintree/ping/failure") do
        expect(result.success?).to be true
        expect(body.dig("errors")).to_not be_empty
      end
    end
  end

  describe "#search" do
    let(:result) { subject.search }

    it "is success" do
      VCR.use_cassette("braintree/search/success") do
        expect(result.success?).to be true
        expect(body.dig("data","search", "transactions", "edges")).to eq []
      end
    end

    it "is failure" do
      VCR.use_cassette("braintree/search/failure") do
        expect(result.success?).to be true
        expect(body.dig("errors")).to_not be_empty
      end
    end
  end

  describe "#createClientToken" do
    let(:result) { subject.createClientToken }

    it "is success" do
      VCR.use_cassette("braintree/createClientToken/success") do
        expect(result.success?).to be true
        expect(body.dig("data","createClientToken", "clientToken")).to_not be_empty
      end
    end

    it "is failure" do
      VCR.use_cassette("braintree/createClientToken/failure") do
        expect(result.success?).to be true
        expect(body.dig("errors")).to_not be_empty
      end
    end
  end

  describe "#tokenizeCreditCard" do
    let(:result) { subject.tokenizeCreditCard(number, expiration, ccv, name) }
    let(:ccv) { "123" }
    let(:name) { "John Doe" }
    let(:expiration) { "11/22" }

    context "when valid data" do
      let(:number) { "4111111111111111" }

      it "is success" do
        VCR.use_cassette("braintree/tokenizeCreditCard/success") do
          expect(result.success?).to be true
          expect(body.dig("data","tokenizeCreditCard")).to_not be_empty
        end
      end
    end

    context "when invalid data" do
      let(:number) { "36259600000004" }

      it "is failure" do
        VCR.use_cassette("braintree/tokenizeCreditCard/failure") do
          expect(result.success?).to be true
          expect(body.dig("errors")).to_not be_empty
        end
      end
    end
  end

  describe "#chargePaymentMethod" do
    let(:result) { subject.chargePaymentMethod(paymentMethodId, amount) }
    let(:amount) { "10.00" }

    context "when valid data" do
      let(:paymentMethodId) { "fake-valid-nonce" }

      it "is success" do
        VCR.use_cassette("braintree/chargePaymentMethod/success") do
          expect(result.success?).to be true
          expect(body.dig("data","chargePaymentMethod")).to_not be_empty
        end
      end
    end

    context "when invalid data" do
      let(:paymentMethodId) { "123" }

      it "is failure" do
        VCR.use_cassette("braintree/chargePaymentMethod/failure") do
          expect(result.success?).to be true
          expect(body.dig("errors")).to_not be_empty
        end
      end
    end
  end

  describe "#chargeCreditCard" do
    let(:result) { subject.chargeCreditCard(paymentMethodId, amount) }
    let(:amount) { "10.00" }

    context "when valid data" do
      let(:paymentMethodId) { "fake-valid-visa-nonce" }

      it "is success" do
        VCR.use_cassette("braintree/chargeCreditCard/success") do
          expect(result.success?).to be true
          expect(body.dig("data","chargeCreditCard")).to_not be_empty
        end
      end
    end

    context "when invalid data" do
      let(:paymentMethodId) { "123" }

      it "is failure" do
        VCR.use_cassette("braintree/chargeCreditCard/failure") do
          expect(result.success?).to be true
          expect(body.dig("errors")).to_not be_empty
        end
      end
    end
  end

  describe "#chargePayPalAccount" do
    let(:result) { subject.chargePayPalAccount(paymentMethodId, amount) }
    let(:amount) { "10.00" }

    context "when valid data" do
      let(:paymentMethodId) { "fake-paypal-one-time-nonce" }

      it "is success" do
        VCR.use_cassette("braintree/chargePayPalAccount/success") do
          expect(result.success?).to be true
          expect(body.dig("data","chargePayPalAccount")).to_not be_empty
        end
      end
    end

    context "when invalid data" do
      let(:paymentMethodId) { "123" }

      it "is failure" do
        VCR.use_cassette("braintree/chargePayPalAccount/failure") do
          expect(result.success?).to be true
          expect(body.dig("errors")).to_not be_empty
        end
      end
    end
  end

  describe "#chargeVenmoAccount" do
    let(:result) { subject.chargeVenmoAccount(paymentMethodId, amount) }
    let(:amount) { "10.00" }

    context "when valid data", skip: "Can't enable venmo on sandbox" do
      let(:paymentMethodId) { "fake-venmo-account-nonce" }

      it "is success" do
        VCR.use_cassette("braintree/chargeVenmoAccount/success") do
          expect(result.success?).to be true
          expect(body.dig("data","chargeVenmoAccount")).to_not be_empty
        end
      end
    end

    context "when invalid data" do
      let(:paymentMethodId) { "123" }

      it "is failure" do
        VCR.use_cassette("braintree/chargeVenmoAccount/failure") do
          expect(result.success?).to be true
          expect(body.dig("errors")).to_not be_empty
        end
      end
    end
  end
end
