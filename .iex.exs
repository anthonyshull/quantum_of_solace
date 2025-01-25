import Ecto.Query, only: [from: 2]

alias QuantumOfSolace.{Repo, Stops.Stop}

Repo.delete_all(Stop)

Repo.insert_all(Stop, [
  %{
    id: "place-north",
    latitude: 42.365577,
    longitude: -71.06129,
    name: "North Station",
  },
  %{
    id: "door-north-crcauseway",
    latitude: 42.366404,
    longitude: -71.061324,
    name: "North Station - Causeway St (East)",
    parent_id: "place-north",
  }
])
