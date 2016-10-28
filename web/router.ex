defmodule Markets.Router do
  use Markets.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :elm_app do
    plug :put_layout, {Markets.LayoutView, :elm_app}
  end

  pipeline :react_app do
    plug :put_layout, {Markets.LayoutView, :react_app}
  end

  scope "/", Markets do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/marketsElm", Markets do
    pipe_through [:browser, :elm_app]
    get "/", ElmAppController, :index
  end

 scope "/marketsReact", Markets do
    pipe_through [:browser, :react_app]
    get "/", ReactAppController, :index
 end

  # Other scopes may use custom stacks.
  # scope "/api", Markets do
  #   pipe_through :api
  # end
end
