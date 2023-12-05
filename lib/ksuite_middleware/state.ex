defmodule KsuiteMiddleware.State do
  alias Timex.TimezoneInfo
  use GenServer

  # Client

  def start_link(default), do: GenServer.start_link(__MODULE__, default, name: State)

  @spec get_ksuite_api_token() :: String.t()
  def get_ksuite_api_token(), do: GenServer.call(State, :get_ksuite_api_token)

  @spec get_kdrive_id() :: String.t()
  def get_kdrive_id(), do: GenServer.call(State, :get_kdrive_id)

  @spec get_caldav_client() :: CalDAVClient.Client.t()
  def get_caldav_client(), do: GenServer.call(State, :get_caldav_client)

  @spec get_timezone() :: Timex.TimezoneInfo.t()
  def get_timezone(), do: GenServer.call(State, :get_timezone)

  # Callbacks

  @impl true
  def init(_) do
    {:ok, %{}}
  end

  @impl true
  def handle_call(:get_ksuite_api_token, _from, %{ksuite_api_token: x} = state),
    do: {:reply, x, state}

  @impl true
  def handle_call(:get_ksuite_api_token, _from, state) do
    api_token = Application.get_env(:ksuite_middleware, :ksuite_api_token)
    {:reply, api_token, Map.put_new(state, :ksuite_api_token, api_token)}
  end

  @impl true
  def handle_call(:get_kdrive_id, _from, %{kdrive_id: x} = state),
    do: {:reply, x, state}

  @impl true
  def handle_call(:get_kdrive_id, _from, state) do
    kdrive_id = Application.get_env(:ksuite_middleware, :kdrive_id)
    {:reply, kdrive_id, Map.put_new(state, :kdrive_id, kdrive_id)}
  end

  @impl true
  def handle_call(:get_caldav_client, _from, %{caldav_client: x} = state),
    do: {:reply, x, state}

  @impl true
  def handle_call(:get_caldav_client, _from, state) do
    username = Application.get_env(:ksuite_middleware, :caldav_username)
    password = Application.get_env(:ksuite_middleware, :caldav_password)
    server = Application.get_env(:ksuite_middleware, :caldav_server)

    client = %CalDAVClient.Client{
      server_url: server,
      auth: %CalDAVClient.Auth.Basic{username: username, password: password}
    }

    {:reply, client, Map.put_new(state, :caldav_client, client)}
  end

  @impl true
  def handle_call(:get_timezone, _from, %{timezone: x} = state), do: {:reply, x, state}

  @impl true
  def handle_call(:get_timezone, _from, state) do
    with %TimezoneInfo{} = timezone <- Application.get_env(:ksuite_middleware, :timezone) |> Timex.Timezone.get() do
      {:reply, timezone, Map.put_new(state, :timezone, timezone)}
    else
      {:error, :time_zone_not_found} -> raise("The environment variable TIMEZONE was missing.")
    end
  end
end
