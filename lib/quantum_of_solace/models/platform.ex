defmodule QuantumOfSolace.Models.Platform do
  @moduledoc false

  use TypedEctoSchema

  import Ecto.Changeset

  alias QuantumOfSolace.Models.Station

  @primary_key false
  @required_fields [:agency, :id, :latitude, :longitude, :name]

  typed_schema "platforms" do
    field(:agency, :string, primary_key: true)
    field(:id, :string, primary_key: true)

    field(:latitude, :float)
    field(:longitude, :float)
    field(:name, :string)

    belongs_to(:station, Station, foreign_key: :parent_id, references: :id, type: :string)
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
