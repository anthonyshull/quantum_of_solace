defmodule QuantumOfSolace.Repos.Migrations.AddSubwayBranchesTable do
  use Ecto.Migration

  def up do
    create table("subway_branches", primary_key: false) do
      add(:agency, :string, primary_key: true)
      add(:id, :string, primary_key: true)

      add(:name, :string)

      add(:line_id, references(:lines, type: :string, with: [agency: :agency]))
    end
  end

  def down do
    drop table("subway_branches")
  end
end
