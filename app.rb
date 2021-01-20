require 'rubygems'
require 'sinatra'
require 'faraday'
require 'dotenv/load'

require './gateways/braintree.rb'

get '/' do
  response = gateway.search
  erb :index, locals: { body: response.body }
end

get '/ping' do
  response = gateway.ping
  erb :show, locals: { body: response.body }
end

get '/clientToken' do
  response = gateway.createClientToken
  erb :show, locals: { body: response.body }
end

get '/creditCardToken' do
  response = gateway.tokenizeCreditCard("4111 1111 1111 1111", "11/22", "123", "Joe Doe", "Lorem Ipsum")
  erb :show, locals: { body: response.body }
end

get '/charge/creditcard' do
  response = gateway.chargeCreditCard("fake-valid-visa-nonce", "10.00")
  erb :show, locals: { body: response.body }
end

get '/charge/paypal' do
  response = gateway.chargePayPalAccount("fake-paypal-one-time-nonce", "10.00")
  erb :show, locals: { body: response.body }
end

get '/charge/venmo' do
  response = gateway.chargeVenmoAccount("fake-venmo-account-nonce", "10.00")
  erb :show, locals: { body: response.body }
end

get '/charge/local' do
  response = gateway.chargePaymentMethod("fake-valid-nonce", "10.00")
  erb :show, locals: { body: response.body }
end

get '*' do
  return '404'
end

private

def gateway
  @_gateway ||= Braintree.new
end
