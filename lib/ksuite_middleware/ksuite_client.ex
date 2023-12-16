defmodule KsuiteMiddleware.KsuiteClient do
  use Tesla

  alias KsuiteMiddleware.State

  require Logger

  plug Tesla.Middleware.BaseUrl, "https://api.infomaniak.com"
  plug Tesla.Middleware.Logger, debug: false
  plug Tesla.Middleware.PathParams
  plug Tesla.Middleware.Headers, [{"User-Agent", "ksuite-middleware"}]
  plug Tesla.Middleware.Headers, [{"Authorization", "Bearer #{State.get_ksuite_api_token()}"}]
  plug Tesla.Middleware.Headers, [{"Content-Type", "application/json"}]
  plug Tesla.Middleware.FollowRedirects, max_redirects: 2
  plug Tesla.Middleware.Retry, max_retries: 5, delay: 10_000

  @spec download(integer()) :: {:error, any()} | {:ok, Tesla.Env.t()}
  def download(file_id) when is_integer(file_id),
    do:
      get("/2/drive/:kdrive_id/files/:file_id/download",
        opts: [path_params: [kdrive_id: State.get_kdrive_id(), file_id: file_id]]
      )

  @spec download_as(integer(), bitstring()) :: {:error, any()} | {:ok, Tesla.Env.t()}
  def download_as(file_id, as \\ "pdf") when is_integer(file_id) and is_bitstring(as),
    do:
      get("/2/drive/:kdrive_id/files/:file_id/download",
        query: [as: as],
        opts: [path_params: [kdrive_id: State.get_kdrive_id(), file_id: file_id]]
      )
end
