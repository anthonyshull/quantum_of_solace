defmodule QuantumOfSolace.Repos.Migrations.AddStationsTable do
  use Ecto.Migration

  def up do
    create table("stations", primary_key: false) do
      add(:agency, :string, primary_key: true)
      add(:id, :string, primary_key: true)

      add(:latitude, :float)
      add(:longitude, :float)
      add(:name, :string)
      add(:wheelchair_boarding, :boolean)

      add(:zone_id, references(:zones, type: :string, with: [agency: :agency]))

      add(:updated_at, :utc_datetime, default: fragment("NOW()"), null: false)
    end
  end

  def down do
    drop table("stations")
  end
end
