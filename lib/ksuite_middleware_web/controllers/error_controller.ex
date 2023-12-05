defmodule KsuiteMiddlewareWeb.ErrorController do
  use KsuiteMiddlewareWeb, :controller

  def not_found(conn, _params),
    do:
      conn
      |> put_resp_header("content-type", "text/html; charset=utf-8")
      |> send_file(404, Application.app_dir(:ksuite_middleware, "priv/static/not-found.html"))
end
