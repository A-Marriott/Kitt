def get_price(duration_minutes)
  tariff = {
    week: 105,
    day: 60,
    hour: 22,
    minute: 2
  }

  minutes_conversion = {
    week: 10080,
    day: 1440,
    hour: 60
  }

  total_price = 0
  duration_left = duration_minutes

  weeks_booked = duration_left / minutes_conversion[:week]
  total_price += tariff[:week] * weeks_booked
  duration_left -= minutes_conversion[:week] * weeks_booked

  days_booked = duration_left / minutes_conversion[:day]
  if days_booked >= 2
    total_price += tariff[:week]
    return total_price
  end
  total_price += tariff[:day] * days_booked
  duration_left -= minutes_conversion[:day] * days_booked

  hours_booked = duration_left / minutes_conversion[:hour]
  if hours_booked >= 3
    total_price += tariff[:day]
    return total_price
  end
  total_price += tariff[:hour] * hours_booked
  duration_left -= minutes_conversion[:hour] * hours_booked

  minutes_booked = duration_left
  if minutes_booked >= 12
    total_price += tariff[:hour]
    return total_price
  end
  total_price += tariff[:minute] * minutes_booked

  return total_price
end

p get_price(140)


# this will be able to be refactored by calling a single function that deals with each level of week/day payments etc. instead of repeating the specifics of each if
# maybe store information in an object for week price, week duration
# use tarrif as term
