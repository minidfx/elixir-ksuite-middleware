defmodule KsuiteMiddleware.KsuiteClient do
  use Tesla

  alias KsuiteMiddleware.State

  require Logger

  plug Tesla.Middleware.BaseUrl, "https://api.infomaniak.com"
  plug Tesla.Middleware.Logger, debug: false
  plug Tesla.Middleware.Headers, [{"User-Agent", "ksuite-middleware"}]
  plug Tesla.Middleware.Headers, [{"Authorization", "Bearer #{State.get_ksuite_api_token()}"}]
  plug Tesla.Middleware.Headers, [{"Content-Type", "application/json"}]
  plug Tesla.Middleware.FollowRedirects, max_redirects: 1

  @spec download(integer()) :: {:error, any()} | {:ok, Tesla.Env.t()}
  def download(file_id) when is_integer(file_id),
    do: get("/2/drive/#{State.get_kdrive_id()}/files/#{file_id}/download")

  @spec download_as(integer(), bitstring()) :: {:error, any()} | {:ok, Tesla.Env.t()}
  def download_as(file_id, as \\ "pdf") when is_integer(file_id) and is_bitstring(as),
    do: get("/2/drive/#{State.get_kdrive_id()}/files/#{file_id}/download", query: [as: as])
end
