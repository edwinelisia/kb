defmodule Kb do
  @moduledoc """
  Documentation for Kb.
  """
  use Application

  def start(_type, _args) do
    children = []
    Kb.Converter.init()
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  defmodule Converter do
    @moduledoc false

    def init do
      :ets.new(:crypto_price, [:set, :public, :named_table])
      :ets.insert(:crypto_price, {:usd, 0})
      :ets.insert(:crypto_price, {:rub, 0})
    end

    def get_btc_to_usd(btc) do
      get_coinbase_usd()
      btc * :ets.lookup(:crypto_price, :usd)[:usd]
    end

    def get_usd_to_btc(usd) do
      get_coinbase_usd()
      usd / :ets.lookup(:crypto_price, :usd)[:usd]
    end

    def get_btc_to_rub(btc) do
      get_coingecko_ruble()
      btc * :ets.lookup(:crypto_price, :rub)[:rub]
    end

    def get_rub_to_btc(rub) do
      get_coingecko_ruble()
      rub / :ets.lookup(:crypto_price, :rub)[:rub]
    end


    defp get_coinbase_usd do
      response = HTTPoison.get! "https://api.pro.coinbase.com/products/BTC-USD/candles?granularity=60"
      last_price = Poison.Parser.parse!(response.body) |> List.last()
      price = (Enum.at(last_price, 1) + Enum.at(last_price, 2)) / 2
      :ets.insert(:crypto_price, {:usd, price})
      :ets.lookup(:crypto_price, :usd)[:usd]
    end

    defp get_coingecko_ruble do
      response = HTTPoison.get! "https://api.coingecko.com/api/v3/exchange_rates"
      price = Poison.Parser.parse!(response.body)["rates"]["rub"]["value"]
      :ets.insert(:crypto_price, {:rub, price})
      :ets.lookup(:crypto_price, :rub)[:rub]
    end
  end
end
