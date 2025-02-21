defmodule QuantumOfSolace.Consumers.Models.Lines do
  use QuantumOfSolace.Consumers.Model

  @impl QuantumOfSolace.Consumers.Model
  def file, do: "lines.txt"

  @impl QuantumOfSolace.Consumers.Model
  # We don't want to treat the Mattapan Trolley as a subway line.
  def reject_row(row) do
    Map.get(row, "line_id") == "line-Mattapan"
  end

  @impl QuantumOfSolace.Consumers.Model
  def row_to_map(row) do
    %{
      id: Map.get(row, "line_id") |> clean_id(),
      color: Map.get(row, "line_color"),
      long_name: Map.get(row, "line_long_name"),
      mode: Map.get(row, "line_color") |> color_to_mode(),
      short_name: Map.get(row, "line_short_name"),
      sort_order: Map.get(row, "line_sort_order") |> String.to_integer()
    }
  end

  defp clean_id(id) do
    id
    |> String.replace("line-", "")
    |> Recase.to_snake()
  end

  defp color_to_mode("FFC72C"), do: :bus
  defp color_to_mode("7C878E"), do: :bus

  defp color_to_mode("008EAA"), do: :ferry

  defp color_to_mode("80276C"), do: :rail
  defp color_to_mode("006595"), do: :rail

  defp color_to_mode("DA291C"), do: :subway
  defp color_to_mode("ED8B00"), do: :subway
  defp color_to_mode("00843D"), do: :subway
  defp color_to_mode("003DA5"), do: :subway
end
