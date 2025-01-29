defmodule QuantumOfSolace.Consumers.Gtfs do
  @moduledoc false

  use QuantumOfSolace.Consumer

  alias QuantumOfSolace.Repos.Control

  @urls %{
    massport: "https://data.trilliumtransit.com/gtfs/massport-ma-us/massport-ma-us.zip",
    mbta: "https://cdn.mbta.com/MBTA_GTFS.zip"
  }

  @impl GenServer
  def handle_cast({:run}, _) do
    sources = Enum.map(@urls, fn {source, _} -> source end)

    Logger.info("#{@process} processing GTFS data from #{Enum.join(sources, " and ")}")

    # Get the last-modified from the URL
    last_modified = @urls |> Map.values() |> get_last_modified()

    # Get the last-modified from the database
    if Timex.before?(Control.last_modified(), last_modified) do
      @urls
      |> Enum.each(fn {source, url} ->
        path = download_gtfs_files(source, url)

        GenServer.cast(QuantumOfSolace.Consumers.Stops, {:process, source, path})
      end)
    else
      Logger.info("#{@process} no new GTFS data to process.")
    end

    {:noreply, Kernel.length(sources)}
  end

  def handle_cast({:complete}, count) do
    new_count = count - 1

    Logger.info("#{@process} source #{count} complete.")

    if new_count == 0 do
      Control.switch_active_repo()
    end

    {:noreply, new_count}
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
        Logger.error("#{@process} failed to download GTFS data from #{source} because #{reason}")

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
