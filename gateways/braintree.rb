# frozen_string_literal: true

class Braintree
  def initialize
    @connection = Faraday.new do |faraday|
      faraday.response :logger, ::Logger.new(STDOUT), bodies: true if logging?
    end
  end

  def ping
    query = read_query("ping")
    input = {}

    request(query, input)
  end

  def search
    query = read_query("search")
    input = { "merchantAccountId": { "is": merchant_id } }

    request(query, input)
  end

  def createClientToken
    query = read_query("tokens/create")
    input = { "clientToken": { "merchantAccountId": merchant_id } }

    request(query, input)
  end

  def tokenizeCreditCard(number, expiration, ccv, name)
    query = read_query("tokens/credit_card")
    input = {
      "creditCard": {
        "number": number,
        "expirationYear": expiration.split('/').last,
        "expirationMonth": expiration.split('/').first,
        "cvv": ccv,
        "cardholderName": name
      }
    }

    request(query, input)
  end

  def chargePaymentMethod(paymentMethodId, amount)
    query = read_query("transactions/any")
    input = {
      "paymentMethodId": paymentMethodId,
      "transaction": { "amount": amount }
    }

    request(query, input)
  end

  def chargeCreditCard(paymentMethodId, amount)
    query = read_query("transactions/creditcard")
    input = {
      "paymentMethodId": paymentMethodId,
      "transaction": { "amount": amount }
    }

    request(query, input)
  end

  def chargePayPalAccount(paymentMethodId, amount)
    query = read_query("transactions/paypal")
    input = {
      "paymentMethodId": paymentMethodId,
      "transaction": { "amount": amount }
    }

    request(query, input)
  end

  def chargeVenmoAccount(paymentMethodId, amount)
    query = read_query("transactions/venmo")
    input = {
      "paymentMethodId": paymentMethodId,
      "transaction": { "amount": amount }
    }

    request(query, input)
  end

  private

  attr_reader :connection

  def request(query, input)
    connection.basic_auth(public_key, private_key)
    connection.post do |faraday|
      faraday.url host
      faraday.headers["Content-Type"] = "application/json"
      faraday.headers["Braintree-Version"] = "2019-01-01"
      faraday.body = { query: query, variables: { input: input } }.to_json
    end
  end

  def read_query(path)
    File.open("gateways/braintree/queries/#{path}.gql").read
  end

  def logging?
    ENV.fetch("BT_LOG") == "true"
  end

  def host
    ENV.fetch("BT_API_URL")
  end

  def public_key
    ENV.fetch("BT_PUBLIC_KEY")
  end

  def private_key
    ENV.fetch("BT_PRIVATE_KEY")
  end

  def merchant_id
    ENV.fetch("BT_MERCHANT_ID")
  end
end
