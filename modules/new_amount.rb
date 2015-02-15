require './modules/exchange_rate'

module CalculateNewAmount

	def CalculateNewAmount.at(amount,date,from,to)
		if amount.to_f <= 0
			return 0.0
		end

		return (amount.to_f * ExchangeRate.at(date,from,to)).round(4)
	end

end
