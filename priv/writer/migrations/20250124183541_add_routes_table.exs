defmodule QuantumOfSolace.Repos.Migrations.AddRoutesTable do
  use Ecto.Migration

  def up do
    create table("routes", primary_key: false) do
      add(:agency, :string, primary_key: true)
      add(:id, :string, primary_key: true)

      add(:description, :string)
      add(:fare_class, :fare_class, default: "free")
      # add(:frequent, :boolean)
      add(:long_name, :string)
      add(:mode, :mode)
      add(:short_name, :string)
      add(:sort_order, :integer)

      add(:line_id, references(:lines, type: :string, with: [agency: :agency]))

      add(:updated_at, :utc_datetime, default: fragment("NOW()"), null: false)
    end
  end

  def down do
    drop table("routes")
  end
end
