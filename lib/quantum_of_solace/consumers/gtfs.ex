defmodule QuantumOfSolace.Consumers.Gtfs do
  @moduledoc false

  use GenServer

  require Logger

  alias QuantumOfSolace.Repos.Control

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
  def handle_cast({:run}, _) do
    # check the last modified date of the GTFS files agains the consumer runs table
    # if the GTFS files have been updated since the last run, download the new files
    # start a timeout clock that will halt the process if we don't complete in time
    # tell the first consumer to process the new files
    {:noreply, nil}
  end

  def handle_cast({:complete, _consumer}) do
    # if this is the last consumer, we switch the active database
    # if there are more consumers, we tell the next consumer to process the new files
    {:noreply, nil}
  end

  defp download_gtfs_files(source, url) do
    source = Atom.to_string(source)
    tmp_dir = System.tmp_dir!()
    dir = Path.join(tmp_dir, source)

    File.rm_rf(dir)
    File.mkdir(dir)
    File.chmod(dir, 0o777)

    path = dir |> Path.join(source <> ".zip")

    with {:ok, :saved_to_file} <-
           :httpc.request(:get, {String.to_charlist(url), []}, [], stream: String.to_charlist(path)),
         {:ok, _files} <- :zip.unzip(String.to_charlist(path), [{:cwd, String.to_charlist(dir)}]) do
      dir
    else
      {:error, reason} ->
        Logger.error("#{__MODULE__} failed to download GTFS data from #{source} because #{reason}")

        nil
    end
  end

  defp get_last_modified(urls) do
    urls
    |> Enum.map(&get_last_modified_header/1)
    |> Enum.reject(fn {status, _} -> status == :error end)
    |> Enum.sort_by(fn {_, datetime} -> datetime end, :desc)
    |> List.first()
    |> Kernel.elem(1)
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
