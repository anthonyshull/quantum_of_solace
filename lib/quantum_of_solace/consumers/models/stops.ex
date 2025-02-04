defmodule QuantumOfSolace.Consumers.Models.Stops do
  use QuantumOfSolace.Consumers.Model

  @impl QuantumOfSolace.Consumers.Model
  def file, do: "stops.txt"

  @impl QuantumOfSolace.Consumers.Model
  def reject_row(row) do
    Map.get(row, "location_type", "") != "0" || Map.get(row, "parent_station", "") != ""
  end

  @impl QuantumOfSolace.Consumers.Model
  def row_to_map(row) do
    %{
      id: Map.get(row, "stop_id"),
      latitude: Map.get(row, "stop_lat") |> String.to_float(),
      longitude: Map.get(row, "stop_lon") |> String.to_float(),
      name: Map.get(row, "stop_name"),
      wheelchair_boarding: Map.get(row, "wheelchair_boarding") == "1",
    }
  end
end
