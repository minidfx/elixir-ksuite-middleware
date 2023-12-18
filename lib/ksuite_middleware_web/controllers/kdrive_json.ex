defmodule KsuiteMiddlewareWeb.KdriveJSON do
  alias KsuiteMiddleware.State

  def render("400.json", %{reason: :invalid_integer}),
    do: %{title: "invalid argument", status: 400, detail: "The given file_id was invalid."}

  def render("400.json", %{reason: :missing_file_id}),
    do: %{title: "missing argument", status: 400, detail: "The file_id was missing."}

  def render("400.json", %{reason: :bad_api_key}),
    do: %{
      title: "bad api key",
      status: 400,
      detail: "The API key is invalid, please verify the 'KSUITE_API_TOKEN'.",
      description:
        "Whoopsie-daisy! Looks like we got a little lost in API land. Our secret handshake seems a bit off. " <>
          "Double-check that magic spell in the enchanted scroll labeled `KSUITE_API_TOKEN` and make sure it's been " <>
          "properly whispered into the winds of the environment variable realm."
    }

  def render("502.json", %{reason: :invalid_response_from_api}),
    do: %{title: "bad gateway", status: 502, detail: "The upstream api returned an invalid response.", server: State.get_ksuite_api_server()}

  def render("500.json", %{reason: :unknown}),
    do: %{title: "internal server error", status: 500, detail: "An unhandled error was returned, please contact the administrator."}

  def render(template, _assigns),
    do: %{detail: Phoenix.Controller.status_message_from_template(template)}
end
