defmodule Helpers do
  def load_massport() do
    GenServer.cast(QuantumOfSolace.Consumers.Gtfs, {:process, :massport, "https://data.trilliumtransit.com/gtfs/massport-ma-us/massport-ma-us.zip"})
  end

  def load_mbta() do
    GenServer.cast(QuantumOfSolace.Consumers.Gtfs, {:process, :mbta, "https://cdn.mbta.com/MBTA_GTFS.zip"})
  end
end

import Helpers

alias QuantumOfSolace.Repos.Control
