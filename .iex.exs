import Ecto.Query, only: [from: 2]

alias QuantumOfSolace.{Models.Stop, Repo}

Repo.delete_all(Stop)

stops =
  "./priv/data/stops.txt"
  |> File.stream!()
  |> CSV.decode!(headers: true)
  |> Stream.map(fn row ->
    Map.put(row, "parent_id", row["parent_station"])
  end)
  |> Enum.to_list()

defmodule Helpers do
  def load_massport() do
    GenServer.cast(QuantumOfSolace.Consumers.Gtfs, {:process, :massport, "https://data.trilliumtransit.com/gtfs/massport-ma-us/massport-ma-us.zip"})
  end

  def load_mbta() do
    GenServer.cast(QuantumOfSolace.Consumers.Gtfs, {:process, :mbta, "https://cdn.mbta.com/MBTA_GTFS.zip"})
  end
end

import Helpers

# Repo.insert_all(Stop, stops)
