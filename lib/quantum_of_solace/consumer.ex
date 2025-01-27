defmodule QuantumOfSolace.Consumer do
  @moduledoc """
  A QoS consumer is a GenServer with a Logger and process identifier.
  """

  defmacro __using__(_) do
    quote do
      use GenServer

      require Logger

      @process __MODULE__
               |> Atom.to_string()
               |> String.split(".")
               |> Kernel.then(fn [_ | tail] -> tail end)
               |> Enum.join(".")

      def start_link(_) do
        GenServer.start_link(__MODULE__, nil, name: __MODULE__)
      end

      @impl GenServer
      def init(_) do
        {:ok, nil}
      end
    end
  end
end
