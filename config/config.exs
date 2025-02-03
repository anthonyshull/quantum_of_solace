import Config

config :quantum_of_solace, QuantumOfSolace.Repos.Control,
  database: "control",
  hostname: "localhost",
  password: "postgres",
  username: "control"

config :quantum_of_solace, QuantumOfSolace.Repos.Blue,
  database: "blue",
  hostname: "localhost",
  password: "postgres",
  username: "blue"

config :quantum_of_solace, QuantumOfSolace.Repos.Green,
  database: "green",
  hostname: "localhost",
  password: "postgres",
  username: "green"

config :quantum_of_solace,
  ecto_repos: [
    QuantumOfSolace.Repos.Control,
    QuantumOfSolace.Repos.Blue,
    QuantumOfSolace.Repos.Green
  ]

config :quantum_of_solace, QuantumOfSolace.Scheduler, jobs: [
  {"* * * * *", {GenServer, :cast, [QuantumOfSolace.Consumers.Gtfs, {:run}]}},
]
