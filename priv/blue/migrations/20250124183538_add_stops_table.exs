defmodule QuantumOfSolace.Repos.Migrations.AddStopsTable do
  use Ecto.Migration

  def up do
    create table("stops", primary_key: false) do
      add(:agency, :string, primary_key: true)
      add(:id, :string, primary_key: true)

      add(:latitude, :float)
      add(:longitude, :float)
      add(:name, :string)
      add(:wheelchair_boarding, :boolean)
    end
  end

  def down do
    drop table("stops")
  end
end
