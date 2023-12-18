defmodule KsuiteMiddlewareWeb.ErrorJSON do
  # If you want to customize a particular status code,
  # you may add your own clauses, such as:
  #
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  def render("404.json", _),
    do: %{
      title: "not found",
      status: 404,
      detail: "The resource requested was not found.",
      description:
        "Oh snap! It seems we've hit a hiccup in our treasure hunt—what you seek is playing hide and seek in the " <>
          "digital jungle! Keep those eagle eyes peeled, and perhaps try a different map or a clever keyword dance " <>
          "to coax the elusive information out of hiding."
    }

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def render(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
