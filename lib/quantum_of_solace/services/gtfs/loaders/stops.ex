defmodule QuantumOfSolace.Services.Gtfs.Loaders.Stops do
  @moduledoc false

  alias QuantumOfSolace.Models.Stop

  @behaviour QuantumOfSolace.Services.Gtfs.Loaders.Behaviour

  def load(_path) do

  end

  defp gtfs_row_to_stop(row) do
    Stop.new(%{
      id: row["stop_id"],
      latitude: row["stop_lat"],
      longitude: row["stop_lon"],
      name: row["stop_name"]
    })
  end
end
