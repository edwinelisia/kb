# kb

## Requirements
- ruby (2.4.1 used)
- bundle install

## To run as it is for 1 BTC
ruby conversion.rb 

## To run as library
- irb
- require_relative 'converter'
- CryptoConverter.convert('btc-usd', 1)


# Elixir
- mix deps.get
- iex -S mix
- Kb.Converter.get_usd_to_btc(10000) (Using ETS)
