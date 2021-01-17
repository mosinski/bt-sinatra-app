# frozen_string_literal: true

module Braintree
  class Connection
    attr_reader :connection

    def initialize(api_connection:)
      @api_connection = api_connection

      @connection = Utilities::Connection.new(host: host, options: options)
    end

    private
    attr_reader :api_connection

    def host
      api_connection.bos_api_url
    end

    def options
      {
        authorization_header: authorization_header
      }
    end

    def authorization_header
      api_connection.bos_api_key
    end
  end
end
