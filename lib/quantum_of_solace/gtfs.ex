defmodule QuantumOfSolace.Gtfs do
  @moduledoc """
  This module is responsible for ingesting GTFS data.
  """

  require Logger

  @process __MODULE__
           |> Atom.to_string()
           |> String.split(".")
           |> Kernel.then(fn [_ | tail] -> tail end)
           |> Enum.join(".")

  def process(source, url) do
    dir = System.tmp_dir!()
    file = Atom.to_string(source) <> ".zip"
    path = dir |> Path.join(file) |> String.to_charlist()

    with {:ok, :saved_to_file} <-
           :httpc.request(:get, {String.to_charlist(url), []}, [], stream: path),
         {:ok, files} <- :zip.unzip(path, [{:cwd, dir}]) do
      files
    else
      {:error, reason} ->
        Logger.error("#{@process} source=#{source} error=#{reason}")

        []
    end
  end
end
