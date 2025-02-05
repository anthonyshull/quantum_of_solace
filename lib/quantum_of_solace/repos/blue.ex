defmodule QuantumOfSolace.Repos.Blue do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres, otp_app: :quantum_of_solace, read_only: true
end
