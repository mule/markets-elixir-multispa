defmodule Markets.ReactAppController do
  use Markets.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
