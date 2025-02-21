defmodule QuantumOfSolace.Repos.Migrations.AddPlatformAlertsTable do
  use Ecto.Migration

  def up do
    create table("platform_alerts", primary_key: false) do
      add(:agency, :string, primary_key: true)

      add(:alert_id, references(:alerts, type: :string, with: [agency: :agency]), primary_key: true)
      add(:platform_id, references(:platforms, type: :string, with: [agency: :agency]), primary_key: true)
    end
  end

  def down do
    drop table("platform_alerts")
  end
end
