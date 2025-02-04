defmodule QuantumOfSolace.Models.Station do
  @moduledoc false

  use TypedEctoSchema

  import Ecto.Changeset

  alias QuantumOfSolace.Models.{Platform, Zone}

  @primary_key false
  @required_fields [:agency, :id, :latitude, :longitude, :name, :wheelchair_boarding]

  typed_schema "stations" do
    field(:agency, :string, primary_key: true)
    field(:id, :string, primary_key: true)

    field(:latitude, :float)
    field(:longitude, :float)
    field(:name, :string)
    field(:wheelchair_boarding, :boolean)

    field(:updated_at, :utc_datetime)

    belongs_to(:zone, Zone, type: :string)
    has_many(:platforms, Platform, foreign_key: :station_id, references: :id)
  end

  def changeset(station, attrs) do
    station
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
