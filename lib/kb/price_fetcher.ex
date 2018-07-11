defmodule Kb.PriceFetcher do
  @moduledoc false
  use Task

  def start_link(_arg) do
    Task.start_link(&get_prices/0)
  end

  def get_prices() do
    receive do
    after
      1_800_000 ->
        IO.puts "30 minutes elapsed, fetching Prices from Coinbase & Coingecko"
        get_coinbase_usd()
        get_coingecko_ruble()
        get_prices()
    end
  end

  def get_coinbase_usd do
    response = HTTPoison.get! "https://api.pro.coinbase.com/products/BTC-USD/candles?granularity=60"
    last_price = Poison.Parser.parse!(response.body) |> List.last()
    price = (Enum.at(last_price, 1) + Enum.at(last_price, 2)) / 2
    :ets.insert(:crypto_price, {:usd, price})
  end

  def get_coingecko_ruble do
    response = HTTPoison.get! "https://api.coingecko.com/api/v3/exchange_rates"
    price = Poison.Parser.parse!(response.body)["rates"]["rub"]["value"]
    :ets.insert(:crypto_price, {:rub, price})
  end
end
