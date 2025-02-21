defmodule QuantumOfSolace.Repos.Migrations.AddStationAlertsTable do
  use Ecto.Migration

  def up do
    create table("station_alerts", primary_key: false) do
      add(:agency, :string, primary_key: true)

      add(:alert_id, references(:alerts, type: :string, with: [agency: :agency]), primary_key: true)
      add(:station_id, references(:stations, type: :string, with: [agency: :agency]), primary_key: true)
    end
  end

  def down do
    drop table("station_alerts")
  end
end
