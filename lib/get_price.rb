def get_price(duration_minutes)
end

# duration provided in minutes
# Series of decreasing modulos, single if statements
# have a price variable that increments as we go through
# have a duration variable that decreases as we go through
# First modulo = week
# increment price count by 105 * modulo
# decrease duration count by 10080 * modulo
# Second modulo = day
# if modulo >= 2, give them the week price, therefore increase price count by 105 (week cost) and return total price (exit function)
# else if modulo is 1/0,
# increment price count by 60*modulo,
# decrease duration count by 1440*modulo
# Third modulo = hour
# if modulo >= 3, give them day price, increase price count by 60 (day cost), return total price (exit function)
# else if modulo is 0/1/2
# increment price count by 22*modulo
# decrease duration count by 60*modulo
# Fourth modulo = minute
# if modulo >= 12, give them hour price, increase price count by 22, return total price
# else if modulo is up to 11,
# increment price by 2*modulo
# no smaller increments so simply return price without worrying about duration



# this will be able to be refactored by calling a single function that deals with each level of week/day payments etc. instead of repeating the specifics of each if
