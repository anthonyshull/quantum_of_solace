defmodule QuantumOfSolace.Models.Platform do
  @moduledoc false

  use TypedEctoSchema

  import Ecto.Changeset

  alias QuantumOfSolace.Models.Station

  @primary_key false
  @required_fields [:agency, :id, :latitude, :longitude, :name, :wheelchair_boarding]

  typed_schema "platforms" do
    field(:agency, :string, primary_key: true)
    field(:id, :string, primary_key: true)

    field(:latitude, :float)
    field(:longitude, :float)
    field(:name, :string)
    field(:wheelchair_boarding, :boolean)

    field(:updated_at, :utc_datetime)

    belongs_to(:station, Station, type: :string)
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
