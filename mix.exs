defmodule QuantumOfSolace.MixProject do
  use Mix.Project

  def project do
    [
      app: :quantum_of_solace,
      version: "0.0.1",
      elixir: "1.18.1",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {QuantumOfSolace.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "3.12.5"},
      {:ecto_sql, "3.12.1"},
      {:quantum, "3.5.3"}
    ]
  end
end
