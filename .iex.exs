defmodule Helpers do
  def gtfs(agency, url) do
    GenServer.cast(QuantumOfSolace.Consumers.Gtfs, {:run, agency, url})
  end

  def massport() do
    agency = "massport"
    url = Application.get_env(:quantum_of_solace, :gtfs_sources)[agency]

    gtfs(agency, url)
  end

  def mbta() do
    agency = "mbta"
    url = Application.get_env(:quantum_of_solace, :gtfs_sources)[agency]

    gtfs(agency, url)
  end
end

import Helpers

alias QuantumOfSolace.Models.Stop
alias QuantumOfSolace.Repo
alias QuantumOfSolace.Repos.Control
