defmodule QuantumOfSolace.Repos.Migrations.AddPlatformsTable do
  use Ecto.Migration

  def up do
    create table("platforms", primary_key: false) do
      add(:agency, :string, primary_key: true)
      add(:id, :string, primary_key: true)

      add(:code, :string)
      add(:latitude, :float)
      add(:longitude, :float)
      add(:name, :string)
      add(:wheelchair_boarding, :boolean)

      add(:station_id, references(:stations, type: :string, with: [agency: :agency]))

      add(:updated_at, :utc_datetime, default: fragment("NOW()"), null: false)
    end
  end

  def down do
    drop table("platforms")
  end
end
