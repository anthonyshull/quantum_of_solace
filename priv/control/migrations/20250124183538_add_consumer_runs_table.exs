defmodule QuantumOfSolace.Repo.Migrations.AddConsumerRunsTable do
  use Ecto.Migration

  def change do
    create table("consumer_runs") do
      add(:agency, :string)
      add(:datetime, :utc_datetime, default: fragment("NOW()"))
      add(:success, :boolean)
    end
  end
end
