require 'typhoeus'
require 'json'

module CryptoConverter
  URL = "https://api.pro.coinbase.com/products/BTC-USD/candles?granularity=60"

  # [1531250160, 6375.99, 6376, 6376, 6375.99, 4.10167669]
  # time bucket start time
  # low lowest price during the bucket interval
  # high highest price during the bucket interval
  # open opening price (first trade) in the bucket interval
  # close closing price (last trade) in the bucket interval
  # volume volume of trading activity during the bucket interval
  def self.btc_to_usd(btc)
    response = Typhoeus.get(URL)
    response_array = JSON.parse(response.response_body)

    last_price = response_array.last
    average_price = (last_price[1] + last_price[2]) / 2
    total_price = btc * average_price
    puts "#{Time.at(last_price.first)}: USD #{total_price} "

    total_price
  end

  def self.usd_to_btc(usd)
    response = Typhoeus.get(URL)
    response_array = JSON.parse(response.response_body)

    last_price = response_array.last
    average_price = (last_price[1] + last_price[2]) / 2
    total_btc = usd / average_price
    puts "#{Time.at(last_price.first)}: BCH #{total_btc}"

    total_btc
  end
end

CryptoConverter.btc_to_usd(1)
CryptoConverter.usd_to_btc(10000)