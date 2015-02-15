require 'rack/test'
require 'sinatra'
require 'test/unit'
require './webapp.rb'
require './modules/exchange_rate'
require './modules/new_amount'

class WebAppTest < Test::Unit::TestCase
	include Rack::Test::Methods

	def app
		Sinatra::Application
	end

	def test_default
		# creating a test example for the default path, namely to check that program loads properly
		get '/'
		assert last_response.body.include?('FX-u-like')
	end

	def test_process
		# creating a test example for the converter and checking that params work
		post '/process/', params = {:date=>Date.today,:amount=>100,:from_ccy=>'GBP',:to_ccy=>'EUR'}

		new_amount = CalculateNewAmount.at(params[:amount],params[:date],params[:from_ccy],params[:to_ccy])
		assert last_response.ok?
		assert last_response.body.include?('Result: ' + new_amount.to_s)

		# creating another test example for the converter
		date = Date.today
		from = 'GBP'
		to = 'GBP'
		result = 100
		# checking the result
		assert_equal 1 , ExchangeRate.at(date,from,to)

		#creating another test example with negative amount
		date = Date.today
		from = 'GBP'
		to = 'EUR'
		result = 0.0
		amount = -2
		# checking the result, it must return 0
		assert_equal result, CalculateNewAmount.at(amount,date,from,to)


	end


end