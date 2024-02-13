defmodule KsuiteMiddlewareWeb.CalendarJSON do
  def events(%{events: events}), do: events

  def render("400.json", %{reason: reason}),
    do: %{title: "invalid argument", status: 400, detail: reason}

  def render("404.json", %{reason: reason}),
    do: %{
      title: "not found",
      status: 404,
      detail: reason,
      description:
        "Oh snap! It seems we've hit a hiccup in our treasure hunt—what you seek is playing hide and seek in the " <>
          "digital jungle! Keep those eagle eyes peeled, and perhaps try a different map or a clever keyword dance " <>
          "to coax the elusive information out of hiding."
    }

  def render("500.json", %{reason: reason}),
    do: %{title: "internal server error", status: 500, detail: reason}

  def render(template, _assigns),
    do: %{detail: Phoenix.Controller.status_message_from_template(template)}
end
