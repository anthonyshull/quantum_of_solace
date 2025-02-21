defmodule QuantumOfSolace.Repos.Migrations.AddLineAlertsTable do
  use Ecto.Migration

  def up do
    create table("line_alerts", primary_key: false) do
      add(:agency, :string, primary_key: true)

      add(:alert_id, references(:alerts, type: :string, with: [agency: :agency]), primary_key: true)
      add(:line_id, references(:lines, type: :string, with: [agency: :agency]), primary_key: true)
    end
  end

  def down do
    # drop table("line_alerts")
  end
end
