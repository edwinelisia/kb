defmodule Kb do
  @moduledoc """
  Documentation for Kb.
  """
  use Application

  def start(_type, _args) do
    children = [Kb.PriceFetcher]
    Kb.Converter.init()
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  defmodule Converter do
    @moduledoc false

    def init do
      :ets.new(:crypto_price, [:set, :public, :named_table])
      Kb.PriceFetcher.get_coinbase_usd()
      Kb.PriceFetcher.get_coingecko_ruble()
    end

    def get_btc_to_usd(btc) do
      btc * :ets.lookup(:crypto_price, :usd)[:usd]
    end

    def get_usd_to_btc(usd) do
      usd / :ets.lookup(:crypto_price, :usd)[:usd]
    end

    def get_btc_to_rub(btc) do
      btc * :ets.lookup(:crypto_price, :rub)[:rub]
    end

    def get_rub_to_btc(rub) do
      rub / :ets.lookup(:crypto_price, :rub)[:rub]
    end
  end
end
