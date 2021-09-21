def get_price(duration_minutes)
  total_price = 0
  duration_left = duration_minutes

  weeks_booked = duration_left / 10080
  total_price += 105 * weeks_booked
  duration_left -= 10080 * weeks_booked

  days_booked = duration_left / 1440
  if days_booked >= 2
    total_price += 105
    return total_price
  end
  total_price += 60 * days_booked
  duration_left -= 1440 * days_booked

  hours_booked = duration_left / 60
  if hours_booked >= 3
    total_price += 60
    return total_price
  end
  total_price += 22 * hours_booked
  duration_left -= 60 * hours_booked

  minutes_booked = duration_left
  if minutes_booked >= 12
    total_price += 22
    return total_price
  end
  total_price += 2 * minutes_booked

  return total_price

  p total_price
  p duration_left
end


get_price(20161)


# this will be able to be refactored by calling a single function that deals with each level of week/day payments etc. instead of repeating the specifics of each if
# maybe store information in an object for week price, week duration
# use tarrif as term
