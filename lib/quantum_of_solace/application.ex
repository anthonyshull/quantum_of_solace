defmodule QuantumOfSolace.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {QuantumOfSolace.Consumers.Gtfs, []},
      {QuantumOfSolace.Consumers.Stops, []},
      {QuantumOfSolace.Repo, []},
      {QuantumOfSolace.Scheduler, []}
    ]

    opts = [strategy: :one_for_one, name: QuantumOfSolace.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
