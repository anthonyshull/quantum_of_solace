defmodule QuantumOfSolace.Consumers.Gtfs do
  @moduledoc false

  use GenServer

  require Logger

  alias QuantumOfSolace.Repos.{Control, DynamicSupervisor}

  @consumers [
    QuantumOfSolace.Consumers.Models.Zones,
    QuantumOfSolace.Consumers.Models.Stations,
    QuantumOfSolace.Consumers.Models.Platforms,
    QuantumOfSolace.Consumers.Models.Stops
  ]

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl GenServer
  def init(_) do
    {:ok, nil}
  end

  @impl GenServer
  def handle_cast({:run, agency, url}, _) do
    {:ok, last_modified_header} = get_last_modified_header(url)
    last_modified_database = Control.get_last_modified(agency)

    if Timex.after?(last_modified_header, last_modified_database) do
      case download_gtfs_files(agency, url) do
        {:ok, directory} ->
          List.first(@consumers) |> GenServer.cast({:run, agency, directory})

          id = Control.start_consumer_run(agency)

          Task.start(fn ->
            Process.sleep(30_000)
            GenServer.cast(__MODULE__, {:halt, id})
          end)

          {:noreply, {id, agency, directory}}

        {:error, reason} ->
          Logger.error("#{__MODULE__} failed to download GTFS files for #{agency}: #{reason}")

          {:noreply, nil}
      end
    else
      Logger.debug("#{__MODULE__} no new GTFS files for #{agency}")

      {:noreply, nil}
    end
  end

  def handle_cast({:complete, completed}, {id, agency, directory}) do
    index = Enum.find_index(@consumers, fn consumer -> consumer == completed end)

    if index == length(@consumers) - 1 do
      DynamicSupervisor.switch()

      Control.stop_consumer_run(id, true)

      {:noreply, nil}
    else
      if Control.consumer_run_active?(id) do
        Enum.at(@consumers, index + 1) |> GenServer.cast({:run, agency, directory})
      end

      {:noreply, {id, agency, directory}}
    end
  end

  def handle_cast({:halt, id}, _) do
    if Control.consumer_run_active?(id) do
      Control.stop_consumer_run(id, false)
    end

    {:noreply, nil}
  end

  defp download_gtfs_files(agency, url) do
    tmp_directory = System.tmp_dir!()
    directory = Path.join(tmp_directory, agency)

    File.rm_rf(directory)
    File.mkdir(directory)
    File.chmod(directory, 0o777)

    path = directory |> Path.join(agency <> ".zip")

    with {:ok, :saved_to_file} <-
           :httpc.request(:get, {String.to_charlist(url), []}, [],
             stream: String.to_charlist(path)
           ),
         {:ok, _files} <-
           :zip.unzip(String.to_charlist(path), [{:cwd, String.to_charlist(directory)}]) do
      {:ok, directory}
    else
      {:error, reason} ->
        {:error, reason}
    end
  end

  defp get_last_modified_header(url) do
    case :httpc.request(:head, {String.to_charlist(url), []}, [], []) do
      {:ok, {{_, 200, _}, headers, _}} ->
        headers
        |> Enum.map(fn {header, value} -> {List.to_string(header), List.to_string(value)} end)
        |> Enum.find(fn {header, _} -> header == "last-modified" end)
        |> Kernel.elem(1)
        |> Timex.parse("%a, %d %b %Y %H:%M:%S %Z", :strftime)

      _ ->
        {:ok, Timex.now()}
    end
  end
end
