defmodule QuantumOfSolace.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {QuantumOfSolace.Consumers.Gtfs, []},
      # MODEL CONSUMERS START
      {QuantumOfSolace.Consumers.Models.Zones, []},
      {QuantumOfSolace.Consumers.Models.Stations, []},
      {QuantumOfSolace.Consumers.Models.Platforms, []},
      {QuantumOfSolace.Consumers.Models.Stops, []},
      # MODEL CONSUMERS END
      {QuantumOfSolace.Repos.Control, []},
      {QuantumOfSolace.Repos.Blue, []},
      {QuantumOfSolace.Repos.Green, []},
      {QuantumOfSolace.Scheduler, []}
    ]

    opts = [strategy: :one_for_one, name: QuantumOfSolace.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
