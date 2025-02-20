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
      {:csv, "3.2.2"},
      {:ecto_sql, "3.12.1"},
      {:gen_stage, "1.2.1"},
      {:inflex, "2.1.0"},
      {:postgrex, "0.19.3"},
      {:quantum, "3.5.3"},
      {:recase, "0.8.1"},
      {:timex, "3.7.11"},
      {:typed_ecto_schema, "0.4.1"}
    ]
  end
end
