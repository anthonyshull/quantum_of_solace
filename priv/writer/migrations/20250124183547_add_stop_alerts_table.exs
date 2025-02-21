defmodule QuantumOfSolace.Repos.Migrations.AddStopAlertsTable do
  use Ecto.Migration

  def up do
    create table("stop_alerts", primary_key: false) do
      add(:agency, :string, primary_key: true)

      add(:alert_id, references(:alerts, type: :string, with: [agency: :agency]), primary_key: true)
      add(:stop_id, references(:stops, type: :string, with: [agency: :agency]), primary_key: true)
    end
  end

  def down do
    drop table("stop_alerts")
  end
end
