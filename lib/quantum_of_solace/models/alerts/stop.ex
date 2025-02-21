defmodule QuantumOfSolace.Models.Alerts.Stop do
  use Ecto.Schema

  schema "stop_alerts" do
    field(:agency, :string)

    belongs_to :alert, QuantumOfSolace.Models.Alert
    belongs_to :stop, QuantumOfSolace.Models.Stop
  end
end
