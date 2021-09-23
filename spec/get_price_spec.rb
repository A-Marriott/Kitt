require 'get_price'

describe '#get_price' do
  it 'returns a number' do
    expect(get_price(0)).to be_a Integer
  end

  it 'costs £2 for a minute long meeting' do
    expect(get_price(1)).to eq(2)
  end

  it 'defaults to the hour cost (£22) for a meeting over 11 minutes' do
    expect(get_price(12)).to eq(22)
  end

  it 'costs £22 for an hour long meeting' do
    expect(get_price(60)).to eq(22)
  end

  it 'costs £30 for an hour and 4 minute long meeting (stacking hour + minute prices)' do
    expect(get_price(64)).to eq(30)
  end

  it 'defaults to the day cost (£60) for a meeting over 11 minutes' do
    expect(get_price(12)).to eq(22)
  end
end
