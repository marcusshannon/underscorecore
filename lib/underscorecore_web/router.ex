defmodule UnderscorecoreWeb.Router do
  use UnderscorecoreWeb, :router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", UnderscorecoreWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/cores", CoreController
    get "/albums/:id", AlbumController, :show
    post "/cores/:id", CoreController, :search
    post "/cores/:id/add", CoreController, :add
    get "/cores/:id/add", CoreController, :add_search
    get "/cores/:id/albums/edit", CoreController, :edit_core_albums
  end

  # Other scopes may use custom stacks.
  # scope "/api", UnderscorecoreWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: UnderscorecoreWeb.Telemetry
    end
  end
end
