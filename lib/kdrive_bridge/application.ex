defmodule KdriveBridge.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      KdriveBridgeWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:kdrive_bridge, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: KdriveBridge.PubSub},
      # Start a worker by calling: KdriveBridge.Worker.start_link(arg)
      # {KdriveBridge.Worker, arg},
      # Start to serve requests, typically the last entry
      KdriveBridgeWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KdriveBridge.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KdriveBridgeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
