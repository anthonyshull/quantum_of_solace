defmodule QuantumOfSolace.Repos.Migrations.AddLinesTable do
  use Ecto.Migration

  def up do
    create table("lines", primary_key: false) do
      add(:agency, :string, primary_key: true)
      add(:id, :string, primary_key: true)

      add(:color, :string)
      add(:mode, :mode)
      add(:name, :string)
      add(:shape, {:array, {:array, :float}})

      add(:updated_at, :utc_datetime, default: fragment("NOW()"), null: false)
    end
  end

  def down do
    drop table("lines")
  end
end
