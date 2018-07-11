defmodule ConverterWeb.CryptoController do
  @moduledoc false
  use ConverterWeb, :controller

  def convert(conn, %{ "fromto" => fromto, "value" => value } = params) do
    "rendering with  #{inspect Map.keys(params)}"
    result = case fromto do
      "btc-usd" ->
        elem(Float.parse(value), 0) * :ets.lookup(:crypto_price, :usd)[:usd]
      "usd-btc" ->
        elem(Float.parse(value), 0) / :ets.lookup(:crypto_price, :usd)[:usd]
      "btc-rub" ->
        elem(Float.parse(value), 0) * :ets.lookup(:crypto_price, :rub)[:rub]
      "rub-btc" ->
        elem(Float.parse(value), 0) / :ets.lookup(:crypto_price, :rub)[:rub]
    end

    IO.puts :ets.lookup(:crypto_price, :usd)[:usd]
    render(conn, "convert.json", value: result)
  end

end
