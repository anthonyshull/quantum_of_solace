import Ecto.Query, only: [from: 2]

alias QuantumOfSolace.{Repo, Stops.Stop}

Repo.delete_all(Stop)

stops =
  "./priv/data/stops.txt"
  |> File.stream!()
  |> CSV.decode!(headers: true)
  |> Stream.map(fn row ->
    Map.put(row, "parent_id", row["parent_station"])
  end)
  |> Enum.to_list()

Repo.insert_all(Stop, stops)
