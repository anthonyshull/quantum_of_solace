defmodule QuantumOfSolace.Models.Station do
  @moduledoc false

  use TypedEctoSchema

  import Ecto.Changeset

  alias QuantumOfSolace.Models.{Platform, Zone}

  @primary_key false
  @required_fields [:agency, :id, :latitude, :longitude, :name]

  typed_schema "stations" do
    field(:agency, :string, primary_key: true)
    field(:id, :string, primary_key: true)

    field(:latitude, :float)
    field(:longitude, :float)
    field(:name, :string)
    field(:wheelchair_boarding, :boolean)

    belongs_to(:zone, Zone, foreign_key: :zone_id, references: :id, type: :string)

    has_many(:platforms, Platform, foreign_key: :station_id, references: :id)
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
