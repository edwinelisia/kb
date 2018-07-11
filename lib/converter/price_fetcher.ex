defmodule ConverterWeb.PriceFetcher do
  @moduledoc false
  use GenServer

  def start_link(_arg) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    :ets.new(:crypto_price, [:set, :public, :named_table])
    get_coinbase_usd()
    get_coingecko_ruble()
    schedule_work() # Schedule work to be performed on start
    {:ok, state}
  end

  def handle_info(:work, state) do
    # Do the desired work here
    IO.puts "30 minutes elapsed, fetching Prices from Coinbase & Coingecko"
    get_coinbase_usd()
    get_coingecko_ruble()

    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 1_800_000) # In 30 minutes
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
