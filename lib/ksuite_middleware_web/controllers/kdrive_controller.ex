defmodule KsuiteMiddlewareWeb.KdriveController do
  use KsuiteMiddlewareWeb, :controller

  alias KsuiteMiddleware.KsuiteClient

  def pass_thru(conn, %{"file_id" => id}) when is_integer(id) do
    with {:ok, response} <- KsuiteClient.download(id) do
      conn |> put_tesla_response(response)
    else
      _ -> conn |> resp(500, "an unknown error occurred.")
    end
  end

  def pass_thru(conn, %{"file_id" => raw_id}) do
    with {file_id, _} <- Integer.parse(raw_id),
         {:ok, response} <- KsuiteClient.download(file_id) do
      conn |> put_tesla_response(response)
    else
      _ ->
        conn |> resp(500, "an unknown error occurred.")
    end
  end

  def pass_thru(conn, _params),
    do: conn |> resp(400, "The file id was missing.")

  # Private

  defp put_tesla_response(%Plug.Conn{} = conn, %Tesla.Env{status: 401}),
    do:
      conn
      |> put_resp_header("content-type", "text/html; charset=utf-8")
      |> send_file(400, Application.app_dir(:ksuite_middleware, "priv/static/bad-api-key.html"))

  defp put_tesla_response(%Plug.Conn{} = conn, %Tesla.Env{} = response) do
    %Tesla.Env{status: status, body: body} = response

    with {:ok, content_type} <- safe_get_header(response, "content-type") do
      conn
      |> put_resp_content_type(content_type)
      |> resp(status, body)
    else
      _ ->
        conn
        |> resp(status, body)
    end
  end

  defp safe_get_header(%Tesla.Env{} = response, header_name) when is_bitstring(header_name) do
    with header_value <- Tesla.get_header(response, header_name),
         false <- is_nil(header_value) do
      {:ok, header_value}
    else
      _ -> {:header_not_found, response}
    end
  end
end