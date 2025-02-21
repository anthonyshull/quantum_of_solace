defmodule QuantumOfSolace.Consumers.Model do
  @moduledoc """
  """

  @callback file() :: String.t()
  @callback reject_map(map :: map) :: boolean
  @callback reject_row(row :: map) :: boolean
  @callback row_to_map(row :: map) :: map

  defmacro __using__(_) do
    quote do
      @behaviour QuantumOfSolace.Consumers.Model

      def reject_map(map), do: false
      def reject_row(row), do: false
      def row_to_map(row), do: row

      defoverridable reject_map: 1, reject_row: 1, row_to_map: 1

      use GenServer

      require Logger

      alias QuantumOfSolace.Repos.Writer

      @consumer __MODULE__
                |> Atom.to_string()
                |> String.split(".")
                |> List.last()

      @model __MODULE__
             |> Atom.to_string()
             |> String.split(".")
             |> Enum.reject(&(&1 == "Consumers"))
             |> Enum.drop(-1)
             |> Enum.concat([Inflex.singularize(@consumer)])
             |> Enum.join(".")
             |> String.to_atom()

      def start_link(_) do
        GenServer.start_link(__MODULE__, nil, name: __MODULE__)
      end

      @impl GenServer
      def init(_) do
        {:ok, nil}
      end

      @impl GenServer
      def handle_cast({:run, agency, directory}, _) do
        path = Path.join(directory, file())

        Logger.info("#{@consumer} processing data from #{agency} at #{path}")

        Writer.start_link()

        ingest(agency, path)

        Writer.stop(1_000)

        GenServer.cast(QuantumOfSolace.Consumers.Gtfs, {:complete, __MODULE__})

        {:noreply, nil}
      end

      def ingest(agency, path) do
        path
        |> File.stream!()
        |> CSV.decode!(headers: true)
        |> Stream.reject(&reject_row/1)
        |> Stream.map(&row_to_map/1)
        |> Stream.reject(&reject_map/1)
        |> Stream.map(&Map.put(&1, :agency, agency))
        |> Stream.filter(fn map ->
          @model.changeset(%@model{}, map).valid?
        end)
        |> Enum.to_list()
        |> Enum.uniq()
        |> Kernel.then(
          &Writer.insert_all(@model, &1,
            on_conflict: :replace_all,
            conflict_target: [:agency, :id]
          )
        )
      end
    end
  end
end
