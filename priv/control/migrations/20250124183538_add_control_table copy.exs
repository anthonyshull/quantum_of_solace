defmodule QuantumOfSolace.Repo.Migrations.AddImportsTable do
  use Ecto.Migration

  def change do
    create table("imports") do
      add(:source, :string)

      add(:start, :utc_datetime)
      add(:stop, :utc_datetime)

      add(:success, :boolean)
    end
  end
end
