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

gtfs_jobs =
  Enum.map(
    [
      massport: "https://data.trilliumtransit.com/gtfs/massport-ma-us/massport-ma-us.zip",
      mbta: "https://cdn.mbta.com/MBTA_GTFS.zip"
    ],
    fn {source, url} ->
      {"@daily", {GenServer, :cast, [QuantumOfSolace.Consumers.Gtfs, {:process, source, url}]}}
    end
  )

config :quantum_of_solace, QuantumOfSolace.Scheduler, jobs: gtfs_jobs
