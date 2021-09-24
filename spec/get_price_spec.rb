require 'get_price'

minutes_conversion = { week: 10080,
                       day: 1440,
                       hour: 60,
                       minute: 1 }

describe '#get_price' do
  it 'returns a number' do
    time = 0
    expect(get_price('minute', time)).to be_a Integer
  end

  context 'minutes' do
    it 'costs £2 for a minute long meeting' do
      time = minutes_conversion[:minute]
      expect(get_price('minute', time)).to eq(2)
    end
  end

  context 'hours' do
    it 'costs £22 for an hour long meeting' do
      time = minutes_conversion[:hour]
      expect(get_price('minute', time)).to eq(22)
    end

    it 'defaults to the hour cost (£22) for a meeting over 11 minutes' do
      time = minutes_conversion[:minute] * 12
      expect(get_price('minute', time)).to eq(22)
    end

    it 'costs £24 for an hour and 1 minute long meeting' do
      time = minutes_conversion[:hour] + minutes_conversion[:minute]
      expect(get_price('minute', time)).to eq(24)
    end
  end

  context 'days' do
    it 'costs £60 for a day long meeting' do
      time = minutes_conversion[:day]
      expect(get_price('minute', time)).to eq(60)
    end

    it 'defaults to the day cost (£60) for a meeting over 3 hours' do
      time = minutes_conversion[:hour] * 3
      expect(get_price('minute', time)).to eq(60)
    end

    it 'defaults to the day cost (£60) for a meeting over 2 hours and 30 minutes' do
      time = minutes_conversion[:hour] * 2 + minutes_conversion[:minute] * 30
      expect(get_price('minute', time)).to eq(60)
    end

    it 'costs £90 for a day, 1 hour and 1 minute long meeting' do
      time = minutes_conversion[:day] + minutes_conversion[:hour] + minutes_conversion[:minute]
      expect(get_price('minute', time)).to eq(84)
    end
  end

  context 'weeks' do
    it 'costs £105 for a week long meeting' do
      time = minutes_conversion[:week]
      expect(get_price('minute', time)).to eq(105)
    end

    it 'defaults to the week cost (£105) for a meeting over 2 days' do
      time = minutes_conversion[:day] * 2
      expect(get_price('minute', time)).to eq(105)
    end

    it 'defaults to the week cost (£105) for a meeting over 1 day, 2 hours and 5 minutes' do
      time = minutes_conversion[:day] + minutes_conversion[:hour] * 2 + minutes_conversion[:minute] * 5
      expect(get_price('minute', time)).to eq(105)
    end

    it 'costs £189 for a week, 1 day, 1 hour and 1 minute long meeting' do
      time = minutes_conversion[:week] + minutes_conversion[:day] + minutes_conversion[:hour] + minutes_conversion[:minute]
      expect(get_price('minute', time)).to eq(189)
    end
  end
end
