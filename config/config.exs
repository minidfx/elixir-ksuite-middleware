# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :ksuite_middleware,
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :ksuite_middleware, KsuiteMiddlewareWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [json: KsuiteMiddlewareWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: KsuiteMiddleware.PubSub,
  live_view: [signing_salt: "7nfCI6sX"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Tesla
config :tesla, adapter: Tesla.Adapter.Hackney

# TzData
config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
