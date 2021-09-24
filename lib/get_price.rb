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

# Unit referes to unit of time, e.g. hour
def get_price(unit, duration_minutes)
  info = if next_unit_of_time[unit]
           get_price(next_unit_of_time[unit], duration_minutes)
         else
           {
             duration_left: duration_minutes,
             items_to_test: [],
             'weeks_cost' => 0,
             'days_cost' => 0,
             'hours_cost' => 0,
             'minutes_cost' => 0
           }
         end
  # We find the numbers of times a given unit can wholly fit into the duration left (e.g. an hour into 150 minutes)
  # An hour fits 2 times into 150 minutes, so we add this to hours_cost (£22 * 2), and take away the quantity of time (60 minutes * 2) from duration_left
  units_booked = info[:duration_left] / minutes_conversion[unit]
  info["#{unit}s_cost"] = tariff[unit] * units_booked
  info[:duration_left] -= minutes_conversion[unit] * units_booked

  # This deals with cases where it's cheaper to get a longer time period (e.g. 1 day = £60) than many smaller time periods (e.g. 2 hours (£44) + 20 minutes (£40) = £84)
  units_to_test = [unit]
  info[:items_to_test].each do |time|
    if units_to_test.map { |tim| info["#{tim}s_cost"] }.inject(:+) > tariff[time]
      units_to_test.each { |tim| info["#{tim}s_cost"] = 0 }
      info["#{time}s_cost"] += tariff[time]
      units_to_test = [time]
      info[:duration_left] = 0
    else
      units_to_test.push(time)
    end
  end
  info[:items_to_test].unshift(unit)

  if unit == 'minute'
    info["weeks_cost"] + info["days_cost"] + info["hours_cost"] + info["minutes_cost"]
    # make sure this isn't explicitly typed, inferred from something
  else
    info
  end
end

p get_price('minute', 1560)

# maybe way to not pass time unit, only duration minutes
# better variable names
# add comments


# def get_price(duration_minutes)
#   tariff = {
#     week: 105,
#     day: 60,
#     hour: 22,
#     minute: 2
#   }

#   minutes_conversion = {
#     week: 10080,
#     day: 1440,
#     hour: 60
#   }


#   # total_price = 0
#   duration_left = duration_minutes

#   whole_weeks_booked = duration_left / minutes_conversion[:week]
#   weeks_cost = tariff[:week] * whole_weeks_booked
#   # total_price += tariff[:week] * whole_weeks_booked
#   duration_left -= minutes_conversion[:week] * whole_weeks_booked

#   whole_days_booked = duration_left / minutes_conversion[:day]
#   days_cost = tariff[:day] * whole_days_booked
#   if days_cost > tariff[:week]
#     return weeks_cost + tariff[:week]
#   end
#   # if whole_days_booked >= 2
#   #   total_price += tariff[:week]
#   #   return total_price
#   # end
#   # total_price += tariff[:day] * whole_days_booked
#   duration_left -= minutes_conversion[:day] * whole_days_booked

#   whole_hours_booked = duration_left / minutes_conversion[:hour]
#   hours_cost = tariff[:hour] * whole_hours_booked
#   if days_cost + weeks_cost + hours_cost > weeks_cost + tariff[:week]
#     return weeks_cost + tariff[:week]
#   end
#   if days_cost + hours_cost > tariff[:day]
#     return weeks_cost + days_cost + tariff[:week]
#   end
#   # if whole_hours_booked >= 3
#   #   total_price += tariff[:day]
#   #   return total_price
#   # end
#   # total_price += tariff[:hour] * whole_hours_booked
#   duration_left -= minutes_conversion[:hour] * whole_hours_booked

#   whole_minutes_booked = duration_left
#   if whole_minutes_booked >= 12
#     total_price += tariff[:hour]
#     return total_price
#   end
#   total_price += tariff[:minute] * whole_minutes_booked

#   return total_price
# end

# p get_price(140)
