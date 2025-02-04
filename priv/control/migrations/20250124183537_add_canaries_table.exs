defmodule QuantumOfSolace.Repo.Migrations.AddCanariesTable do
  use Ecto.Migration

  def change do
    create table("canaries", primary_key: false) do
      add(:datetime, :utc_datetime, default: fragment("NOW()"))
      add(:from, :string)
      add(:to, :string)
    end
  end
end
