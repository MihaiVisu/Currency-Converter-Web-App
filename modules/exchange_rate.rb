require 'nokogiri'
require 'open-uri'

module ExchangeRate

	def ExchangeRate.at(date, from, to)

		rateFrom = 0
		rateTo = 0
		target_url = URI.escape("http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml")
		doc = Nokogiri::XML(open(target_url))
		doc.css('Cube').each do |element|
			if element['time'] == date.to_s
				element.children.each do |r|
					if r['currency'] == from
						rateFrom = r['rate'].to_f
					elsif from == 'EUR' # treating special case when converting from EUR
						rateFrom = 1.0.round(4)
					end

					if r['currency'] == to
						rateTo = r['rate'].to_f
					elsif to == 'EUR' # treating special case when converting to EUR
						rateTo = 1.0.round(4)
					end
					#exit the function and return the result when found both rates to decrease time
					if(rateTo != 0 && rateFrom != 0)
						return rateTo/rateFrom
					end
				end
			end
		end
		if(rateFrom==0)
			return 0
		end
		return rateTo/rateFrom
	end
end