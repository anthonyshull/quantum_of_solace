alias QuantumOfSolace.Consumers
alias QuantumOfSolace.Models
alias QuantumOfSolace.Repos

defmodule Helpers do
  def gtfs(agency, url) do
    GenServer.cast(Consumers.Gtfs, {:run, agency, url})
  end

  def massport() do
    agency = "massport"
    url = "https://data.trilliumtransit.com/gtfs/massport-ma-us/massport-ma-us.zip"

    gtfs(agency, url)
  end

  def mbta() do
    agency = "mbta"
    url = "https://cdn.mbta.com/MBTA_GTFS.zip"

    gtfs(agency, url)
  end
end

import Helpers

defmodule AlertHelpers do
  alias PgRanges.{TstzMultirange, TstzRange}
  alias QuantumOfSolace.Models
  alias QuantumOfSolace.Repos.Writer

  @lower_bound Timex.now() |> Timex.shift(years: -10)
  @upper_bound Timex.now() |> Timex.shift(years: 10)

  def active_period_range(nil, nil) do
    TstzRange.new(@lower_bound, @upper_bound)
  end

  def active_period_range(nil, stop) do
    TstzRange.new(@lower_bound, stop)
  end

  def active_period_range(start, nil) do
    TstzRange.new(start, @upper_bound)
  end

  def active_period_range(start, stop) do
    TstzRange.new(start, stop)
  end

  def alert_active_period(%{start: start, end: stop}) do
    start = timestamp_to_datetime(start)
    stop = timestamp_to_datetime(stop)

    active_period_range(start, stop)
  end

  def alert_active_periods(%{active_period: active_period}) when is_list(active_period) do
    ranges = Enum.map(active_period, &alert_active_period/1)

    TstzMultirange.new(ranges)
  end

  def alert_active_periods(_), do: nil

  def alert_effect(%{effect: effect}) do
    effect
    |> Atom.to_string()
    |> String.downcase()
    |> String.to_atom()
  end

  def alert_effect(_), do: nil

  def alert_effect_detail(%{effect_detail: %{translation: [%{text: text}]}}) do
    text
    |> String.downcase()
    # |> String.to_atom()
  end

  def alert_effect_detail(_), do: nil

  def maybe_inform_entities(%{id: id, informed_entities: informed_entities}) do
    Enum.each(informed_entities, fn entity ->
      maybe_inform_line(id, entity)
      # maybe_inform_platform(id, entity)
      # maybe_inform_station(id, entity)
      # maybe_inform_stop(id, entity)
    end)
  end

  def maybe_inform_line(_, %{route_id: nil}), do: nil

  def maybe_inform_line(id, %{route_id: route_id}) do
    IO.inspect(route_id, label: "ROUTE ID")
    if Writer.get_by(Models.Line, agency: "mbta", id: String.downcase(route_id)) do
      query = "INSERT INTO line_alerts (agency, alert_id, line_id) VALUES ('mbta', '#{id}', '#{String.downcase(route_id)}')"

      Ecto.Adapters.SQL.query!(Writer, query, [])
    end
  end

  def maybe_inform_platform(_, %{stop_id: nil}), do: nil

  def maybe_inform_platform(id, %{stop_id: stop_id}) do
    if Writer.get_by(Models.Platform, agency: "mbta", id: String.downcase(stop_id)) do
      query = "INSERT INTO platform_alerts (agency, alert_id, platform_id) VALUES ('mbta', '#{id}', '#{String.downcase(stop_id)}')"
      Ecto.Adapters.SQL.query!(Writer, query, [])
    end
  end

  def maybe_inform_station(_, %{stop_id: nil}), do: nil

  def maybe_inform_station(id, %{stop_id: stop_id}) do
    if Writer.get_by(Models.Station, agency: "mbta", id: String.downcase(stop_id)) do
      query = "INSERT INTO station_alerts (agency, alert_id, station_id) VALUES ('mbta', '#{id}', '#{String.downcase(stop_id)}')"
      Ecto.Adapters.SQL.query!(Writer, query, [])
    end
  end

  def maybe_inform_stop(_, %{stop_id: nil}), do: nil

  def maybe_inform_stop(id, %{stop_id: stop_id}) do
    if Writer.get_by(Models.Stop, agency: "mbta", id: String.downcase(stop_id)) do
      query = "INSERT INTO stop_alerts (agency, alert_id, stop_id) VALUES ('mbta', '#{id}', '#{String.downcase(stop_id)}')"
      Ecto.Adapters.SQL.query!(Writer, query, [])
    end
  end

  def timestamp_to_datetime(nil), do: nil

  def timestamp_to_datetime(timestamp) do
    with {:ok, datetime} <- DateTime.from_unix(timestamp),
         datetime <- Timex.to_datetime(datetime, "America/New_York") do
          datetime
         else
            _ -> nil
         end
  end
end

Application.get_env(:quantum_of_solace, QuantumOfSolace.Repos.Writer) |> QuantumOfSolace.Repos.Writer.start_link()

import AlertHelpers

alerts_url = "https://cdn.mbta.com/realtime/Alerts.pb" |> String.to_charlist()
alerts_path = "priv/data/alerts.pb" |> String.to_charlist()

# {:ok, :saved_to_file} = :httpc.request(:get, {alerts_url, []}, [], stream: alerts_path)

{:ok, binary} = File.read(alerts_path)

alerts =
  binary
  |> TransitRealtime.FeedMessage.decode()
  |> Map.get(:entity)
  |> Enum.map(fn %{id: id, alert: alert} ->
    active_periods = alert_active_periods(alert)
    effect = alert_effect(alert)
    effect_detail = alert_effect_detail(alert)

    %{agency: "mbta", id: id, active_periods: active_periods, effect: effect, effect_detail: effect_detail}
  end)
  |> Enum.uniq_by(& &1.id)

informed_entities =
  binary
  |> TransitRealtime.FeedMessage.decode()
  |> Map.get(:entity)
  |> Enum.map(fn %{id: id, alert: alert} ->
    %{id: id, informed_entities: alert.informed_entity}
  end)
  |> Enum.uniq_by(& &1.id)
  |> Enum.each(& maybe_inform_entities/1)

# QuantumOfSolace.Repos.Writer.insert_all(QuantumOfSolace.Models.Alert, alerts)
