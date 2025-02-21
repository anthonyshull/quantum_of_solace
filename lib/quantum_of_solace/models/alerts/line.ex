defmodule QuantumOfSolace.Models.Alerts.Line do
  use Ecto.Schema

  schema "line_alerts" do
    field(:agency, :string)

    belongs_to :alert, QuantumOfSolace.Models.Alert
    belongs_to :line, QuantumOfSolace.Models.Line
  end
end
