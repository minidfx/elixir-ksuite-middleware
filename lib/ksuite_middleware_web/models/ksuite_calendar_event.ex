defmodule KsuiteMiddlewareWeb.Models.KsuiteCalendarEvent do
  @enforce_keys [:subject, :from, :to, :description]
  @derive Jason.Encoder
  defstruct [:subject, :from, :to, :description]
  @type t :: %__MODULE__{subject: String.t(), from: String.t(), to: String.t(), description: String.t()}
end
