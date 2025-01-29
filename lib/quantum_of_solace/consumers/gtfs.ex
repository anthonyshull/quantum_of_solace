defmodule QuantumOfSolace.Consumers.Gtfs do
  @moduledoc false

  use QuantumOfSolace.Consumer

  alias QuantumOfSolace.Repos.Control

  @impl GenServer
  def handle_cast({:process, source, url}, _) do
    Logger.info("#{@process}: processing GTFS data from #{source} at #{url}.")

    # Get the last-modified from the URL
    {:ok, last_modified_header} = get_last_modified_header(url)
    last_modified_from_database = get_last_modified_from_database(source)

    # Get the last-modified from the database
    if Timex.before?(last_modified_header, last_modified_from_database) do
      path = download_gtfs_files(source, url)

      GenServer.cast(QuantumOfSolace.Consumers.Stops, {:process, source, path})
    end

    {:noreply, nil}
  end

  def handle_cast({:complete}, _) do
    Logger.info("#{@process} complete. Switching active repo to #{Control.get_passive_repo()}.")

    Control.switch_active_repo()

    {:noreply, nil}
  end

  defp download_gtfs_files(source, url) do
    dir = System.tmp_dir!()
    file = Atom.to_string(source) <> ".zip"
    path = dir |> Path.join(file) |> String.to_charlist()

    "rm #{Path.join(dir, "*")}" |> String.to_charlist() |> :os.cmd()

    with {:ok, :saved_to_file} <-
           :httpc.request(:get, {String.to_charlist(url), []}, [], stream: path),
         {:ok, _files} <- :zip.unzip(path, [{:cwd, String.to_charlist(dir)}]) do
      dir
    else
      {:error, reason} ->
        Logger.error("#{@process} source=#{source} error=#{reason}")

        nil
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
        nil
    end
  end

  defp get_last_modified_from_database(_source) do
    Timex.now()
  end
end
