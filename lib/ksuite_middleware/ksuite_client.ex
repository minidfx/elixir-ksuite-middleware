defmodule KsuiteMiddleware.KsuiteClient do
  require Logger
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://api.infomaniak.com"
  plug Tesla.Middleware.Logger, debug: false
  plug Tesla.Middleware.Headers, [{"User-Agent", "ksuite-middleware"}]
  plug Tesla.Middleware.Headers, [{"Authorization", "Bearer #{Application.get_env(:ksuite_middleware, :ksuite_api_token)}"}]
  plug Tesla.Middleware.Headers, [{"Content-Type", "application/json"}]
  plug Tesla.Middleware.FollowRedirects, max_redirects: 1

  @spec download(integer()) :: {:error, any()} | {:ok, Tesla.Env.t()}
  def download(file_id) when is_integer(file_id) do
    kdrive_id = Application.get_env(:ksuite_middleware, :kdrive_id)
    get("/2/drive/#{kdrive_id}/files/#{file_id}/download")
  end

  @spec download_as(integer(), bitstring()) :: {:error, any()} | {:ok, Tesla.Env.t()}
  def download_as(file_id, as \\ "pdf") when is_integer(file_id) and is_bitstring(as) do
    kdrive_id = Application.get_env(:ksuite_middleware, :kdrive_id)
    get("/2/drive/#{kdrive_id}/files/#{file_id}/download", query: [as: as])
  end
end
