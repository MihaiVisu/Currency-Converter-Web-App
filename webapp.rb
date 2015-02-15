
require 'sinatra'
require 'open-uri'
require 'nokogiri'
require './modules/exchange_rate'
require './modules/new_amount'

set :port, 8080
set :static, true
set :public_folder, "static"
set :views, "views"

# escaping the URL string to make it valid when opening
target_url = URI.escape("http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml")

#declaring currencies array, representing options from the select input
currencies = Array.new
# add EURO currency
currencies.push('<option>EUR</option>')

# opening the xml file from the website
doc = Nokogiri::XML(open(target_url))

# set the default values of the inputs
result = 0.0
date = Date.today
amount = 0
# getting the unique currencies from the XML webpage
doc.css('Cube').each do |response|
	elem = response['currency']
	if elem != nil
		if(elem == 'GBP') # setting GBP the default seelcted currency
			currencies.push('<option selected="selected">'+elem+'</option>')
		else
			currencies.push('<option>'+elem+'</option>')
		end
	end
end

# remove duplicates from currencies list and sort them alphabetically
currencies = currencies.uniq


get '/' do 

	# set all the values of the inputs to keep them after refreshing the page
 	erb :index, :locals => { 'currencies' => currencies, 
 		'result' => result,
 		'date' => date,
 		'amount' => amount
 	}
 							
end

post '/process/' do

	# getting parameters

 	date = params[:date] || Date.today
 	amount = params[:amount] || 0
 	from_ccy = params[:from_ccy] || "GBP"
 	to_ccy = params[:to_ccy] || "GBP"

 	result = CalculateNewAmount.at(amount,date,from_ccy,to_ccy)

 	# set all the values of the inputs to keep them after refreshing the page
 	erb :index, :locals => {'currencies' =>currencies, 
 		'result' => result,
 		'date' => date,
 		'amount' => amount
 	}
end
