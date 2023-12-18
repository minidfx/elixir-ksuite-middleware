defmodule KsuiteMiddlewareWeb.KdriveController do
  use KsuiteMiddlewareWeb, :controller

  alias KsuiteMiddleware.KsuiteClient

  action_fallback KsuiteMiddleware.FallbackController

  def pass_thru(conn, %{"file_id" => id}) when is_integer(id) do
    with {:ok, response} <- KsuiteClient.download(id) do
      conn |> put_tesla_response(response)
    else
      _ ->
        conn
        |> put_status(:bad_gateway)
        |> render(:"500")
    end
  end

  def pass_thru(conn, %{"file_id" => raw_id}) do
    with {file_id, _} <- Integer.parse(raw_id),
         {:ok, response} <- KsuiteClient.download(file_id) do
      conn |> put_tesla_response(response)
    else
      :error ->
        conn
        |> put_status(:bad_request)
        |> put_resp_content_type("application/problem+json")
        |> render(:"400", reason: :invalid_integer)

      {:error, _} ->
        conn
        |> put_status(:bad_gateway)
        |> put_resp_content_type("application/problem+json")
        |> render(:"502", reason: :invalid_response_from_api)

      _ ->
        conn
        |> put_status(:internal_server_error)
        |> put_resp_content_type("application/problem+json")
        |> render(:"500", reason: :unknown)
    end
  end

  def pass_thru(conn, _params),
    do:
      conn
      |> put_status(:bad_request)
      |> put_resp_content_type("application/problem+json")
      |> render(:"400", reason: :missing_file_id)

  # Private

  defp put_tesla_response(%Plug.Conn{} = conn, %Tesla.Env{status: 401}),
    do:
      conn
      |> put_status(:bad_request)
      |> put_resp_content_type("application/problem+json")
      |> render(:"400", reason: :bad_api_key)

  defp put_tesla_response(%Plug.Conn{} = conn, %Tesla.Env{} = response) do
    %Tesla.Env{status: status, body: body} = response

    with {:ok, content_type} <- safe_get_header(response, "content-type") do
      conn
      |> put_resp_content_type(content_type)
      |> resp(status, body)
    else
      _ ->
        conn
        |> put_status(status)
        |> render(status |> Integer.to_string() |> String.to_atom())
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
