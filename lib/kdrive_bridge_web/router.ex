defmodule KdriveBridgeWeb.Router do
  use KdriveBridgeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/files", KdriveBridgeWeb do
    pipe_through :api

    get "/:file_id", MainController, :pass_thru
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:kdrive_bridge, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: KdriveBridgeWeb.Telemetry
    end
  end

  scope "/", KdriveBridgeWeb do
    pipe_through :browser

    get "/*path", MainController, :index
  end
end