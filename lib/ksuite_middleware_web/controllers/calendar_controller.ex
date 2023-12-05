defmodule KsuiteMiddlewareWeb.CalendarController do
  use KsuiteMiddlewareWeb, :controller

  alias KsuiteMiddlewareWeb.Models.KsuiteCalendarEvent
  alias KsuiteMiddleware.State
  alias Timex.TimezoneInfo

  require Logger

  def get_events(conn, %{"from" => from, "to" => to, "calendar_id" => calendar_id}),
    do:
      parse_params(from, to, calendar_id)
      |> then(&read_events/1)
      |> then(&translate_to_events/1)
      |> then(&send_response(conn, &1))

  # Private

  defp read_events({:error, error, reason}), do: {:error, error, reason}

  defp read_events({:ok, from, to, calendar_id}) do
    client = State.get_caldav_client()
    %CalDAVClient.Client{auth: %CalDAVClient.Auth.Basic{username: username}} = client
    calendar_url = CalDAVClient.URL.Builder.build_calendar_url(username, calendar_id)

    Logger.info("Reading the events from the calendar #{calendar_id} ...")

    client |> CalDAVClient.Event.get_events(calendar_url, from, to)
  end

  defp send_response(conn, {:ok, events}), do: json(conn, events)

  defp send_response(conn, {:error, error, reason}),
    do:
      conn
      |> put_status(error)
      |> json(%{reason: reason})

  defp send_response(conn, {:error, reason}),
    do:
      conn
      |> put_status(500)
      |> json(%{reason: reason})

  defp parse_params(from, to, calendar_id) do
    Logger.info("Parsing the arguments ...")

    with {:ok, from} <- parse_datetime(:invalid_from, from),
         {:ok, to} <- parse_datetime(:invalid_to, to),
         {:ok, calendar_id} <- parse_calendar_id(calendar_id) do
      {:ok, from, to, calendar_id}
    else
      :invalid_to -> {:error, :bad_request, "The argument 'to' was invalid."}
      :invalid_from -> {:error, :bad_request, "The argument 'from' was invalid."}
      {:invalid_calendar_id, reason} -> {:error, :bad_request, reason}
    end
  end

  defp parse_calendar_id(calendar_id) when byte_size(calendar_id) <= 100, do: {:ok, calendar_id}
  defp parse_calendar_id(_), do: {:invalid_calendar_id, "The calendar_id was too long."}

  defp parse_datetime(error_atom, datetime) when is_atom(error_atom) and is_bitstring(datetime) do
    case Timex.parse!(datetime, "{ISO:Extended:Z}") do
      %DateTime{} = x -> {:ok, x}
      _ -> error_atom
    end
  end

  defp translate_to_events({:error, :unauthorized}), do: {:error, :unauthorized, "Unauthorized access to the CalDAV server, double check your credentials."}
  defp translate_to_events({:error, :not_found}), do: {:error, :not_found, "The given calendar_id was not found in the given server CalDAV."}
  defp translate_to_events({:error, reason}), do: {:error, reason}
  defp translate_to_events({:error, error, reason}), do: {:error, error, reason}
  defp translate_to_events({:ok, []}), do: {:ok, []}
  defp translate_to_events({:ok, icalendar_events}), do: translate_to_events(icalendar_events, [])
  defp translate_to_events([], acc) when is_list(acc), do: {:ok, acc}

  defp translate_to_events([head | tail], acc) when is_list(acc) do
    %CalDAVClient.Event{icalendar: icalendar_event} = head
    [%ICalendar.Event{} = event] = ICalendar.from_ics(icalendar_event)
    %ICalendar.Event{summary: summary, dtstart: from, dtend: to, description: description} = event

    # Because the start and end date don't contain the timezone when it is a daily event, we have to recompute the datetime to the configured timezone.
    from = translate_date_to_utc(from)
    to = translate_date_to_utc(to)

    new_event = %KsuiteCalendarEvent{subject: summary, from: Timex.format!(from, "{ISO:Extended:Z}"), to: Timex.format!(to, "{ISO:Extended:Z}"), description: description}

    translate_to_events(tail, [new_event | acc])
  end

  defp translate_date_to_utc(%DateTime{time_zone: "Etc/UTC", hour: 0, minute: 0, second: 0} = datetime) do
    %DateTime{year: y, month: m, day: d} = datetime
    %TimezoneInfo{full_name: tz} = State.get_timezone()

    Timex.to_date({y, m, d})
    |> Timex.to_datetime(tz)
    |> Timex.Timezone.convert(:utc)
  end

  defp translate_date_to_utc(datetime), do: datetime
end
