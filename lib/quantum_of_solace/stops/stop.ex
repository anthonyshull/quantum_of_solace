defmodule QuantumOfSolace.Stops.Stop do
  @moduledoc false

  use TypedEctoSchema

  @primary_key false

  typed_schema "stops" do
    field(:id, :string, enforce: true, primary_key: true)

    field(:latitude, :float, enforce: true, null: false)
    field(:longitude, :float, enforce: true, null: false)
    field(:name, :string, enforce: true, null: false)

    belongs_to(:parent, __MODULE__, foreign_key: :parent_id, references: :id, type: :string)
    has_many(:children, __MODULE__, foreign_key: :parent_id, references: :id)
  end
end
