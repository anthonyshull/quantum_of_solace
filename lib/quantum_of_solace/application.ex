defmodule QuantumOfSolace.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # MAIN CONSUMER
      {QuantumOfSolace.Consumers.Gtfs, []},
      # MODEL CONSUMERS
      {QuantumOfSolace.Consumers.Models.Zones, []},
      {QuantumOfSolace.Consumers.Models.Stations, []},
      {QuantumOfSolace.Consumers.Models.Platforms, []},
      {QuantumOfSolace.Consumers.Models.Stops, []},
      # BLUE/GREEN REPOS SUPERVSOR
      {QuantumOfSolace.Repos.DynamicSupervisor, []},
      # REPOS
      {QuantumOfSolace.Repos.Control, []},
      # QUANTUM SCHEDULER
      {QuantumOfSolace.Scheduler, []}
    ]

    opts = [strategy: :one_for_one, name: QuantumOfSolace.Supervisor]

    main_app = Supervisor.start_link(children, opts)

    DynamicSupervisor.start_child(
      QuantumOfSolace.Repos.DynamicSupervisor,
      QuantumOfSolace.Repos.DynamicSupervisor.passive()
    )

    main_app
  end
end
