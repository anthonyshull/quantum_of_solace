defmodule QuantumOfSolace.Repos.Migrations.AddAlertsTable do
  use Ecto.Migration

  def up do
    create table("alerts", primary_key: false) do
      add(:agency, :string, primary_key: true)
      add(:id, :string, primary_key: true)

      add(:effect, :string)
      add(:effect_detail, :string)

      add(:active_periods, :tstzmultirange)

      add(:updated_at, :utc_datetime, default: fragment("NOW()"), null: false)
    end
  end

  def down do
    drop table("alerts")
  end
end
