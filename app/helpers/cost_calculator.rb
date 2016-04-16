module CostCalculator
	PER_DAY_COST = {
		"1234" => [4200,6500,7500,14500]
	}

	PER_HOUR_COST = {
		"1234" => [450,750,1450,1450,2700]
	}

	def per_day_cost(lisp,kva)
		ret = 0
		if PER_DAY_COST[lisp].present?
			ret = PER_DAY_COST[lisp][kva_index(kva)]
		end
		ret
	end

	def per_hour_cost(lisp,kva)
		ret = 0
		if PER_HOUR_COST[lisp].present?
			ret = PER_HOUR_COST[lisp][kva_index(kva)]
		end
		ret
	end

	def kva_index(kva)
		kvai = kva.to_i
		if(kvai > 130)
			return 3
		elsif(kvai > 70)
			return 2
		elsif kvai > 30
			return 1
		else
			return 0
		end
	end

end