defmodule QuantumOfSolace.Models.Alerts.Station do
  use Ecto.Schema

  schema "station_alerts" do
    field(:agency, :string)

    belongs_to :alert, QuantumOfSolace.Models.Alert
    belongs_to :station, QuantumOfSolace.Models.Station
  end
end
