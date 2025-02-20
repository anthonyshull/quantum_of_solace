defmodule QuantumOfSolace.Repos.Migrations.AddFareClassEnum do
  use Ecto.Migration

  def up do
    execute("CREATE TYPE fare_class AS ENUM ('bus', 'ferry', 'free', 'rail', 'rapid_transit', 'special');")
  end

  def down do
    execute("DROP TYPE fare_class;")
  end
end
