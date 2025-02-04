defmodule QuantumOfSolace.Consumers.Models.Zones do
  use QuantumOfSolace.Consumers.Model

  @impl QuantumOfSolace.Consumers.Model
  def file, do: "stops.txt"

  @impl QuantumOfSolace.Consumers.Model
  # Reject rows where the zone_id is missing or empty.
  def reject_row(row) do
    Map.get(row, "zone_id", "") == ""
  end

  @impl QuantumOfSolace.Consumers.Model
  def row_to_map(row) do
    %{
      id: row["zone_id"]
    }
  end
end
