defmodule QuantumOfSolace.Repos.Migrations.AddLinesTable do
  use Ecto.Migration

  def up do
    create table("lines", primary_key: false) do
      add(:agency, :string, primary_key: true)
      add(:id, :string, primary_key: true)

      add(:color, :string)
      add(:mode, :mode)
      add(:long_name, :string)
      add(:shape, {:array, {:array, :float}})
      add(:short_name, :string)
      add(:sort_order, :integer)

      add(:updated_at, :utc_datetime, default: fragment("NOW()"), null: false)
    end
  end

  def down do
    drop table("lines")
  end
end
