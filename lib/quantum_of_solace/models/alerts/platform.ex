defmodule QuantumOfSolace.Models.Alerts.Platform do
  use Ecto.Schema

  schema "platform_alerts" do
    field(:agency, :string)

    belongs_to :alert, QuantumOfSolace.Models.Alert
    belongs_to :platform, QuantumOfSolace.Models.Platform
  end
end
