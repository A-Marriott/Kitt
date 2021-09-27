def get_price(time_unit, duration_minutes)
  info = if next_unit_of_time[time_unit]
           get_price(next_unit_of_time[time_unit], duration_minutes)
         else
           init_info(duration_minutes)
         end

  # This handles the calculation for adding the cost of a period of time (e.g. 2 days of booking), and subsequently taking away the relevant amount of time from the total.
  time_units_booked = info[:duration_left] / minutes_conversion[time_unit]
  info["#{time_unit}s_cost"] = tariff[time_unit] * time_units_booked
  info[:duration_left] -= minutes_conversion[time_unit] * time_units_booked

  # Sometimes it's cheaper to use a longer time period (e.g. 1 day = £60) than many smaller time periods (e.g. 2 hours (£44) + 20 minutes (£40) = £84)
  # We need to incrementally test smaller units against larger units, seeing if the sum of smaller units outweights a larger unit e.g. if an hour is cheaper than many minutes, if a day is cheaper than many hours + minutes etc.
  # smaller_time_units holds information on what to incrementally test, larger_time_units contains the units we've already iterated through (starting with week)
  smaller_time_units = [time_unit]
  info[:larger_time_units].each do |larger_time_unit|
    cost_of_smaller_time_units = smaller_time_units.map { |smaller_time_unit| info["#{smaller_time_unit}s_cost"] }.inject(:+)
    if cost_of_smaller_time_units > tariff[larger_time_unit]
      smaller_time_units.each { |smaller_time_unit| info["#{smaller_time_unit}s_cost"] = 0 }
      info["#{larger_time_unit}s_cost"] += tariff[larger_time_unit]
      smaller_time_units = [larger_time_unit]
      info[:duration_left] = 0
    else
      smaller_time_units.push(larger_time_unit)
    end
  end
  info[:larger_time_units].unshift(time_unit)

  if time_unit == 'minute'
    tariff.map { |k, _| info["#{k}s_cost"] }.inject(:+)
  else
    info
  end
end

# puts get_price('minutes', 253)

# The below methods contain reference information to be passed to the get_price method
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
    larger_time_units: [],
    'weeks_cost' => 0,
    'days_cost' => 0,
    'hours_cost' => 0,
    'minutes_cost' => 0
  }
end
