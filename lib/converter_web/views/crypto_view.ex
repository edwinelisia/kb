defmodule ConverterWeb.CryptoView do
  @moduledoc false
  use ConverterWeb, :view

  def render("convert.json", %{value: value}) do
    %{value: value}
  end
end
