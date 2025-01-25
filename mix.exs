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
      extra_applications: [:inets, :logger],
      mod: {QuantumOfSolace.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ayesql, "1.1.3"},
      {:ecto_sql, "3.12.1"},
      {:exconstructor, "1.2.13"},
      {:postgrex, "0.19.3"},
      {:quantum, "3.5.3"},
      {:typed_struct, "0.3.0"}
    ]
  end
end
