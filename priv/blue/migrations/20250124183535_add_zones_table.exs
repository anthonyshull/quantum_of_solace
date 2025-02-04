defmodule QuantumOfSolace.Repos.Migrations.AddZonesTable do
  use Ecto.Migration

  alias QuantumOfSolace.Models.Station

  def up do
    create table("zones", primary_key: false) do
      add(:agency, :string, primary_key: true)
      add(:id, :string, primary_key: true)

      add(:updated_at, :utc_datetime, default: fragment("NOW()"), null: false)
    end
  end

  def down do
    drop table("zones")
  end
end
