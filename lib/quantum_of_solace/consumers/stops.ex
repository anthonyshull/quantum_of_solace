defmodule QuantumOfSolace.Consumers.Stops do
  @moduledoc false

  use QuantumOfSolace.Consumer

  alias QuantumOfSolace.{Models.Stop, Repo}

  @impl GenServer
  def handle_cast({:process, source, path}, _) do
    Logger.info("#{@process} processing stops data from #{source} at #{path}")

    import_stops(path) |> IO.inspect(label: "IMPORT")

    GenServer.cast(QuantumOfSolace.Consumers.Gtfs, {:complete})

    {:noreply, nil}
  end

  defp import_stops(path) do
    (path <> "stops.txt")
    |> sort_stops_by_parent_id()
    |> File.stream!()
    |> CSV.decode!(headers: true)
    |> Stream.map(&row_to_map/1)
    |> Stream.reject(&reject_map/1)
    |> Stream.map(&map_to_data/1)
    |> Stream.filter(fn map ->
      Stop.changeset(%Stop{}, map).valid?
    end)
    |> Stream.chunk_every(100)
    |> Task.async_stream(&insert_batch/1, max_concurrency: 10, ordered: false)
    |> Stream.run()
  end

  defp insert_batch(data) do
    Repo.insert_all(Stop, data, on_conflict: :replace_all, conflict_target: [:id])
  end

  defp map_to_data(data) do
    %{
      id: data.id,
      latitude: data.latitude |> String.to_float(),
      longitude: data.longitude |> String.to_float(),
      name: data.name,
      parent_id: (if data.parent_id == "", do: nil, else: data.parent_id)
    }
  end

  defp reject_map(map) do
    map.latitude == "" || map.longitude == ""
  end

  defp row_to_map(row) do
    %{
      id: row["stop_id"],
      latitude: row["stop_lat"],
      longitude: row["stop_lon"],
      name: row["stop_name"],
      parent_id: row["parent_station"]
    }
  end

  defp sort_stops_by_parent_id(path) do
    "(head -n 2 #{path}stops.txt && tail -n +3 #{path}stops.txt | sort -k 14) > #{path}stops.txt"
    |> Kernel.to_charlist()
    |> :os.cmd()

    path
  end
end
