defmodule QuantumOfSolace.Models.Zone do
  @moduledoc false

  use TypedEctoSchema

  import Ecto.Changeset

  alias QuantumOfSolace.Models.Station

  @primary_key false
  @required_fields [:agency, :id]

  typed_schema "stations" do
    field(:agency, :string, primary_key: true)
    field(:id, :string, primary_key: true)

    has_many(:stations, Station, foreign_key: :zone_id, references: :id)
  end

  def changeset(zone, attrs) do
    zone
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
