defmodule ConverterWeb.CryptoController do
  @moduledoc false
  use ConverterWeb, :controller

  def convert(conn, %{ "fromto" => fromto, "value" => value } = params) do
    float_value = elem(Float.parse(value), 0)

    result = case fromto do
      "btc-usd" ->
        float_value * :ets.lookup(:crypto_price, :usd)[:usd]
      "usd-btc" ->
        float_value / :ets.lookup(:crypto_price, :usd)[:usd]
      "btc-rub" ->
        float_value * :ets.lookup(:crypto_price, :rub)[:rub]
      "rub-btc" ->
        float_value / :ets.lookup(:crypto_price, :rub)[:rub]
    end
    
    render(conn, "convert.json", value: result)
  end

end
