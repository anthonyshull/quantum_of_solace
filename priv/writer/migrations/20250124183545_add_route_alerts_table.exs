defmodule QuantumOfSolace.Repos.Migrations.AddRouteAlertsTable do
  use Ecto.Migration

  def up do
    create table("route_alerts", primary_key: false) do
      add(:agency, :string, primary_key: true)

      add(:alert_id, references(:alerts, type: :string, with: [agency: :agency]), primary_key: true)
      add(:route_id, references(:routes, type: :string, with: [agency: :agency]), primary_key: true)
    end
  end

  def down do
    drop table("route_alerts")
  end
end
