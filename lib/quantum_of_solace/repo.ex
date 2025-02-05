defmodule QuantumOfSolace.Repo do
  @moduledoc """

  """

  for {function, arg_count} <- QuantumOfSolace.Repos.Blue.__info__(:functions) do
    if arg_count == 0 do
      def unquote(function)() do
        QuantumOfSolace.Repos.DynamicSupervisor.active().unquote(function)()
      end
    else
      args = for i <- 1..arg_count, do: {:"arg#{i}", [], Elixir}

      def unquote(function)(unquote_splicing(args)) do
        QuantumOfSolace.Repos.DynamicSupervisor.active().unquote(function)(unquote_splicing(args))
      end
    end
  end
end
