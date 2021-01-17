# frozen_string_literal: true

class Braintree
  def initialize(client = Faraday.new)
    @connection = client
  end

  def ping
    query = read_query("ping")
    input = {}

    request(query, input)
  end

  def chargePaymentMethod
    query = read_query("transactions/create")
    input = { "paymentMethodId": "nonce_from_the_client", "transaction": { "amount": "10.00" } }

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

  def host
    ENV['BT_API_URL']
  end

  def public_key
    ENV['BT_PUBLIC_KEY']
  end

  def private_key
    ENV['BT_PRIVATE_KEY']
  end
end
