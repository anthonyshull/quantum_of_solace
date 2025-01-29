defmodule Helpers do
  def gtfs() do
    GenServer.cast(QuantumOfSolace.Consumers.Gtfs, {:run})
  end
end

import Helpers

alias QuantumOfSolace.Models.Stop
alias QuantumOfSolace.Repo
alias QuantumOfSolace.Repos.Control
