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

def step_list
  {
    'minute' => 'hour',
    'hour' => 'day',
    'day' => 'week'
  }
end

def get_price(time_unit, duration_minutes)
  if step_list[time_unit]
    info = get_price(step_list[time_unit], duration_minutes)
  else
    info = {
      duration_left: duration_minutes,
      'weeks_booked' => 0,
      'days_booked' => 0,
      'hours_booked' => 0,
      'minutes_booked' => 0,
      'weeks_cost' => 0,
      'days_cost' => 0,
      'hours_cost' => 0,
      'minutes_cost' => 0,
      exit_function?: false,
      items_to_test: []
    }
  end
  # make this less imperative
  return info if info[:exit_function?] && time_unit != 'minute'

  info["#{time_unit}s_booked"] = info[:duration_left] / minutes_conversion[time_unit]
  info["#{time_unit}s_cost"] = tariff[time_unit] * info["#{time_unit}s_booked"]
  info[:duration_left] -= minutes_conversion[time_unit] * info["#{time_unit}s_booked"]
  times_tested = [time_unit]
  info[:items_to_test].each do |time|
    if times_tested.map { |tim| info["#{tim}s_cost"] }.inject(:+) > tariff[time]
      times_tested.each { |tim| info["#{tim}s_cost"] = 0 }
      info["#{time}s_cost"] += tariff[time]
      times_tested = [time]
      info[:exit_function?] = true
    else
      times_tested.push(time)
    end
  end
  info[:items_to_test].unshift(time_unit)

  if time_unit == 'minute'
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


# # this will be able to be refactored by calling a single function that deals with each level of week/day payments etc. instead of repeating the specifics of each if
# # maybe store information in an object for week price, week duration
# # use tarrif as term
