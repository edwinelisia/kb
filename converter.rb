require 'typhoeus'
require 'json'

module CryptoConverter
  COINBASE_BTC_USD_URL = "https://api.pro.coinbase.com/products/BTC-USD/candles?granularity=60"
  COINGECKO_EXCHANGE_RATE_URL = "https://api.coingecko.com/api/v3/exchange_rates"

  # COINBASE
  # [1531250160, 6375.99, 6376, 6376, 6375.99, 4.10167669]
  # time bucket start time
  # low lowest price during the bucket interval
  # high highest price during the bucket interval
  # open opening price (first trade) in the bucket interval
  # close closing price (last trade) in the bucket interval
  # volume volume of trading activity during the bucket interval

  # btc-usd, usd-btc, btc-rub, rub-btc
  def self.convert(from_to='btc-usd', value)
    from_to.downcase!
    if from_to.include?("usd")
      response = Typhoeus.get(COINBASE_BTC_USD_URL)
      response_array = JSON.parse(response.response_body)
      last_price = response_array.last
      average_price = (last_price[1] + last_price[2]) / 2
      
      from, to = from_to.split('-')
      if from == 'btc'
        value * average_price
      else
        value / average_price
      end
    else
      response = Typhoeus.get(COINGECKO_EXCHANGE_RATE_URL)
      response_hash = JSON.parse(response.response_body)
      ruble_value = response_hash['rates']['rub']['value']

      from, to = from_to.split('-')
      if from == 'btc'
        value * ruble_value
      else
        value / ruble_value
      end
    end
  end
end

puts CryptoConverter.convert('btc-usd', 1)
puts CryptoConverter.convert('usd-btc', 10000)
puts CryptoConverter.convert('btc-rub', 1)
puts CryptoConverter.convert('rub-btc', 10000)