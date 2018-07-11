defmodule ConverterWeb.PageController do
  use ConverterWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
