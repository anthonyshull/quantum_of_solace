defmodule QuantumOfSolace.Models.Route do
  @moduledoc false

  use TypedEctoSchema

  @primary_key false

  typed_schema "routes" do
    field(:agency, :string, primary_key: true)
    field(:id, :string, primary_key: true)
  end
end
