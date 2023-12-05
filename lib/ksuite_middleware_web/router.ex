defmodule KsuiteMiddlewareWeb.Router do
  use KsuiteMiddlewareWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", KsuiteMiddlewareWeb do
    pipe_through :browser

    get "/", MainController, :index
  end

  scope "/files", KsuiteMiddlewareWeb do
    pipe_through :api

    get "/:file_id", KdriveController, :pass_thru
  end

  scope "/calendars", KsuiteMiddlewareWeb do
    pipe_through :api

    get "/:calendar_id", CalendarController, :get_events
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:ksuite_middleware, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: KsuiteMiddlewareWeb.Telemetry
    end
  end

  scope "/", KsuiteMiddlewareWeb do
    pipe_through :browser

    get "/*path", ErrorController, :not_found
  end
end
