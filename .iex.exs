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
