defmodule QuantumOfSolace.Consumers.Models.Behaviour do
  @moduledoc """
  """

  @callback reject_map(map :: map) :: boolean
  @callback reject_row(row :: map) :: boolean
  @callback row_to_map(row :: map) :: map

  defmacro __using__(_) do
    quote do
      @behaviour __MODULE__

      def reject_map(map), do: false
      def reject_row(row), do: false
      def row_to_map(row), do: row

      defoverridable [reject_map: 1, reject_row: 1, row_to_map: 1]

      use GenServer

      require Logger

      @consumer __MODULE__
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

      @impl GenServer
      def handle_cast({:process, agency, path}, _) do
        Logger.info("#{@consumer} processing stops data from #{source} at #{path}")

        import(agency, path)

        {:noreply, nil}
      end

      def import(agency, file) do
        file
        |> File.stream!()
        |> CSV.decode!(headers: true)
        |> Stream.map(&reject_row/1)
        |> Stream.map(&row_to_map/1)
        |> Stream.reject(&reject_map/1)
        |> Stream.map(&map_to_data/1)
        |> Stream.filter(fn map ->
          model.changeset(%model{agency: agency}, map).valid?
        end)
        |> Enum.to_list()
        |> Kernel.then(
          &Repo.passive().insert_all(model, &1, on_conflict: :replace_all, conflict_target: [:agency, :id])
        )
      end
    end
  end
end
