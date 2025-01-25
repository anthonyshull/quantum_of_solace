defmodule QuantumOfSolace.Stops.Queries do
  @moduledoc false

  use AyeSQL, repo: QuantumOfSolace.Repo

  defqueries("queries.sql") # File name with relative path to SQL file.
end
