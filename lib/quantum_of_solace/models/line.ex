defmodule QuantumOfSolace.Models.Line do
  @moduledoc false

  use TypedEctoSchema

  import Ecto.Changeset

  @primary_key false
  @required_fields [:agency, :id, :color, :long_name]

  # add(:color, :string)
  # add(:mode, :mode)
  # add(:long_name, :string)
  # add(:shape, {:array, {:array, :float}})
  # add(:short_name, :string)
  # add(:sort_order, :integer)

  typed_schema "lines" do
    field(:agency, :string, primary_key: true)
    field(:id, :string, primary_key: true)

    field(:color, :string)
    field(:mode, Ecto.Enum, values: [:bus, :ferry, :rail, :subway])
    field(:long_name, :string)
    field(:shape, {:array, {:array, :float}})
    field(:short_name, :string)
    field(:sort_order, :integer)

    field(:updated_at, :utc_datetime)
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
