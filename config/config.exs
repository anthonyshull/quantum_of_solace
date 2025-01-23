import Config

config :quantum_of_solace, QuantumOfSolace.Repo,
  database: "postgres",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

gtfs_jobs =
  Enum.map(
    [
      massport: "https://data.trilliumtransit.com/gtfs/massport-ma-us/massport-ma-us.zip",
      mbta: "https://cdn.mbta.com/MBTA_GTFS.zip"
    ],
    fn {source, url} -> {"@daily", {QuantumOfSolace.Gtfs, :process, [source, url]}} end
  )

config :quantum_of_solace, QuantumOfSolace.Scheduler,
  jobs: gtfs_jobs
