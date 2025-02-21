defmodule QuantumOfSolace.Models.Effect do
  @effects TransitRealtime.Alert.Effect.mapping()
           |> Map.keys()
           |> Enum.map(&Atom.to_string/1)
           |> Enum.map(&String.downcase/1)
           |> Enum.map(&String.to_atom/1)

  def effects(), do: @effects
end
