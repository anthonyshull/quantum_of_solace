defmodule QuantumOfSolace.Repos.Migrations.AddModesEnum do
  use Ecto.Migration

  def up do
    execute("CREATE TYPE mode AS ENUM ('bus', 'ferry', 'rail', 'subway');")
  end

  def down do
    execute("DROP TYPE mode;")
  end
end
