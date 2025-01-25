defmodule QuantumOfSolace.Stops.Stop do
  @moduledoc false

  use ExConstructor
  use TypedStruct

  typedstruct do
    field :id, String.t(), enforce: true
    field :latitude, float(), enforce: true
    field :longitude, float(), enforce: true
    field :name, String.t(), enforce: true
  end
end
