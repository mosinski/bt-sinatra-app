# frozen_string_literal: true

module Braintree
  class Client
    def initialize(connection:)
      @connection = connection
    end

    def ping
      query = File.open("queries/ping.gql").read
      input = {}

      request(query, input)
    end

    def chargePaymentMethod(params)
      request(
        "GetAppointmentDataById"
      ).execute(
        params: params
      )
    end

    private

    def request(query, input)
      @_request ||= Faraday.post do |faraday|
        faraday.url = url
        #faraday.request request
        #faraday.response response
        #faraday.adapter :httpclient
        faraday.basic_auth(public_key, private_key)
        faraday.headers["Content-Type"] = "application/json"
        faraday.form = { query: query, variables: { input: input } }
      end
    end

    def url
      ENV['BT_API_URL']
    end

    def public_key
      ENV['BT_PUBLIC_KEY']
    end

    def private_key
      ENV['BT_PRIVATE_KEY']
    end
  end
end
