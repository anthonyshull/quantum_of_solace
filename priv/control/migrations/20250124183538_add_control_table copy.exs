defmodule QuantumOfSolace.Repo.Migrations.AddConsumerRunsTable do
  use Ecto.Migration

  def change do
    create table("consumer_runs") do
      add(:agency, :string)

      add(:start, :utc_datetime)
      add(:stop, :utc_datetime)

      add(:success, :boolean)
    end
  end
end
