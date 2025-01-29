defmodule QuantumOfSolace.Repo.Migrations.AddCanariesTable do
  use Ecto.Migration

  def change do
    create table("canaries", primary_key: false) do
      add(:from, :string)
      add(:to, :string)

      add(:datetime, :utc_datetime, default: fragment("NOW()"))
    end
  end
end
