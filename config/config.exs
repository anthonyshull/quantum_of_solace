import Config

config :quantum_of_solace, QuantumOfSolace.Repos.Control,
  database: "control",
  hostname: "localhost",
  password: "postgres",
  username: "postgres"

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

config :quantum_of_solace, QuantumOfSolace.Repos.Writer,
  database: "writer",
  hostname: "localhost",
  password: "postgres",
  username: "postgres"

config :quantum_of_solace,
  ecto_repos: [
    QuantumOfSolace.Repos.Control,
    QuantumOfSolace.Repos.Writer
  ]

config :quantum_of_solace, QuantumOfSolace.Scheduler,
  jobs: [
    {"0 * * * *",
     {GenServer, :cast,
      [QuantumOfSolace.Consumers.Gtfs, {:run, "mbta", "https://cdn.mbta.com/MBTA_GTFS.zip"}]}},
    {"5 * * * *",
     {GenServer, :cast,
      [
        QuantumOfSolace.Consumers.Gtfs,
        {:run, "massport",
         "https://data.trilliumtransit.com/gtfs/massport-ma-us/massport-ma-us.zip"}
      ]}}
  ]
