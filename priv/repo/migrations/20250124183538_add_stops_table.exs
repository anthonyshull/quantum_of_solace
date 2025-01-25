defmodule QuantumOfSolace.Repo.Migrations.AddStopsTable do
  use Ecto.Migration

  def change do
    create table("stops", primary_key: false) do
      add(:id, :string, primary_key: true)

      add(:latitude, :float)
      add(:longitude, :float)
      add(:name, :string)
    end
  end
end
