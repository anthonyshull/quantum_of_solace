defmodule QuantumOfSolace.Repo do
  @moduledoc """
  A reusable Ecto Repo module.
  """

  alias QuantumOfSolace.Repos.Control

  defmacro __using__(_) do
    quote do
      use Ecto.Repo, adapter: Ecto.Adapters.Postgres, otp_app: :quantum_of_solace
    end
  end

  def active() do
    Application.get_env(:quantum_of_solace, :active_repo, Control.get_active_repo())
  end

  def passive() do
    QuantumOfSolace.Repos.Control.get_passive_repo()
  end
end
