defmodule QuantumOfSolace.Repo.Migrations.AddStopsTable do
  use Ecto.Migration

  def change do
    create table("stops", primary_key: false) do
      add(:id, :string, primary_key: true)

      add(:latitude, :float)
      add(:longitude, :float)
      add(:name, :string)
      add(:parent_id, :string)
    end

    execute("""
    ALTER TABLE stops
    ADD CONSTRAINT parent_id_fk
    FOREIGN KEY (parent_id)
    REFERENCES stops(id)
    ON DELETE CASCADE;
    """)
  end
end
