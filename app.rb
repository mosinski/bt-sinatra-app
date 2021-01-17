require 'rubygems'
require 'sinatra'
require 'faraday'
require 'dotenv/load'

require './gateways/braintree.rb'

get '/' do
  erb :index
end

get '/ping' do
  response = Braintree.new.ping
  erb :show, locals: { body: response.body }
end

get '/charge' do
  response = Braintree.new.chargePaymentMethod
  erb :show, locals: { body: response.body }
end

get '*' do
  return '404'
end
