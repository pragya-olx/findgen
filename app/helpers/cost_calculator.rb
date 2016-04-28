module CostCalculator
  PER_DAY_COST = {
    "1234" => [4200,6500,7500,14500]
  }

  PER_HOUR_COST = {
    "1234" => [450,750,1450,1450,2700]
  }

  def per_day_cost(lisp,kva)
    location = get_location(lisp)
    if location.nil?
      return 0
    end
    kva_index(location, kva, "day")
  end

  def per_hour_cost(lisp,kva)
    location = get_location(lisp)
    if location.nil?
      return 0
    end
    kva_index(location, kva, "hour")
  end

  def kva_index(location, kva, rate_type)
    kvai = kva.to_i
    if(kvai > 130)
      return rate_type == "day" ? location.kva_250_day : location.kva_250_hour
    elsif(kvai > 70)
      return rate_type == "day" ? location.kva_130_day : location.kva_130_hour
    elsif kvai > 30
      return rate_type == "day" ? location.kva_70_day : location.kva_70_hour
    else
      return rate_type == "day" ? location.kva_30_day : location.kva_30_hour
    end
  end

  def get_location(lisp_code)
    lisp = Lisp.find_by_code(lisp_code)
    if lisp.present?
      location = Location.find_by_state(lisp.state)
      return location
    end
    nil
  end

end