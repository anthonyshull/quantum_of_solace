defmodule QuantumOfSolace.Models.Alert do
  @moduledoc false

  use TypedEctoSchema

  alias QuantumOfSolace.Models

  @primary_key false

  typed_schema "alerts" do
    field(:agency, :string, primary_key: true)
    field(:id, :string, primary_key: true)

    field(:effect, Ecto.Enum, values: QuantumOfSolace.Models.Effect.effects())
    field(:effect_detail, :string)

    field(:active_periods, PgRanges.TstzMultirange)

    many_to_many :lines, Models.Line, join_through: Models.Alerts.Line
    many_to_many :platforms, Models.Platform, join_through: Models.Alerts.Platform
    many_to_many :stations, Models.Station, join_through: Models.Alerts.Station
    many_to_many :stops, Models.Stop, join_through: Models.Alerts.Stop

    field(:updated_at, :utc_datetime)
  end
end
