defmodule QuantumOfSolace.Models.Stop do
  @moduledoc false

  use TypedEctoSchema

  import Ecto.Changeset

  @primary_key false
  @required_fields [:id, :latitude, :longitude, :name]

  typed_schema "stops" do
    field(:id, :string, primary_key: true)

    field(:latitude, :float)
    field(:longitude, :float)
    field(:name, :string)

    belongs_to(:parent, __MODULE__, foreign_key: :parent_id, references: :id, type: :string)
    has_many(:children, __MODULE__, foreign_key: :parent_id, references: :id)
  end

  def changeset(stop, attrs) do
    stop
    |> cast(attrs, all_fields())
    |> validate_required(required_fields())
  end

  defp all_fields() do
    __MODULE__.__schema__(:fields)
  end

  defp required_fields() do
    @required_fields
  end
end
