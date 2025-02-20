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

alerts_url = "https://cdn.mbta.com/realtime/Alerts.pb" |> String.to_charlist()
alerts_path = "priv/data/alerts.pb" |> String.to_charlist()

{:ok, :saved_to_file} = :httpc.request(:get, {alerts_url, []}, [], stream: alerts_path)

{:ok, binary} = File.read(alerts_path)

alerts =
  binary
  |> TransitRealtime.FeedMessage.decode()
  |> Map.get(:entity)
  |> Enum.map(&Map.get(&1, :alert))
