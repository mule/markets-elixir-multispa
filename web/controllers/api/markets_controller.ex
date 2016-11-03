defmodule Markets.MarketsController do
  use Markets.Web, :controller

  def index(conn, _params) do
    query = Markets.Market
    data = Repo.all(query)
    json conn, data
  end
end
