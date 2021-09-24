# Unit referes to unit of time, e.g. hour
def get_price(unit, duration_minutes)
  info = if next_unit_of_time[unit]
           get_price(next_unit_of_time[unit], duration_minutes)
         else
           init_info(duration_minutes)
         end
  # e.g. An hour fits 2 times into 150 minutes, so we would add this to hours_cost (£22 * 2), and take away the quantity of time (60 minutes * 2) from duration_left
  units_booked = info[:duration_left] / minutes_conversion[unit]
  info["#{unit}s_cost"] = tariff[unit] * units_booked
  info[:duration_left] -= minutes_conversion[unit] * units_booked

  # This deals with cases where it's cheaper to use a longer time period (e.g. 1 day = £60) than many smaller time periods (e.g. 2 hours (£44) + 20 minutes (£40) = £84)
  # We need to incrementally test units against larger units e.g. if an hour is cheaper than many minutes, if a day is cheaper than many hours + minutes etc.
  # smaller_units holds information on what to incrementally test, larger_units contains the units we've already iterated through (starting with week), attempting to see if the sum of smaller units outweights a larger unit, meaning we use the larger (therefore cheaper) unit instead
  smaller_units = [unit]
  info[:larger_units].each do |larger_unit|
    cost_of_smaller_units = smaller_units.map { |smaller_unit| info["#{smaller_unit}s_cost"] }.inject(:+)
    if cost_of_smaller_units > tariff[larger_unit]
      smaller_units.each { |smaller_unit| info["#{smaller_unit}s_cost"] = 0 }
      info["#{larger_unit}s_cost"] += tariff[larger_unit]
      smaller_units = [larger_unit]
      info[:duration_left] = 0
    else
      smaller_units.push(larger_unit)
    end
  end
  info[:larger_units].unshift(unit)

  if unit == 'minute'
    info["weeks_cost"] + info["days_cost"] + info["hours_cost"] + info["minutes_cost"]
    # make sure this isn't explicitly typed, inferred from something
  else
    info
  end
end

# better variable names
# add comments

def tariff
  {
    'week' => 105,
    'day' => 60,
    'hour' => 22,
    'minute' => 2
  }
end

def minutes_conversion
  {
    'week' => 10080,
    'day' => 1440,
    'hour' => 60,
    'minute' => 1
  }
end

def next_unit_of_time
  {
    'minute' => 'hour',
    'hour' => 'day',
    'day' => 'week'
  }
end

def init_info(duration_minutes)
  {
    duration_left: duration_minutes,
    larger_units: [],
    'weeks_cost' => 0,
    'days_cost' => 0,
    'hours_cost' => 0,
    'minutes_cost' => 0
  }
end
