defmodule QuantumOfSolace.Services.Gtfs.Loader do
  @moduledoc """
  This module is responsible for ingesting GTFS data.
  """

  require Logger

  @models ~w[stop]

  @process __MODULE__
           |> Atom.to_string()
           |> String.split(".")
           |> Kernel.then(fn [_ | tail] -> tail end)
           |> Enum.join(".")

  @doc """
  Load all Gtfs data from a given source according to a defined order.
  """
  def load_all(source, url) do
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

  @doc """
  Load one Gtfs file.
  """
  def load_one(path) do
    name = path_to_model_name(path)

    if Enum.member?(@models, name) do
      model = QuantumOfSolace.Models.__MODULE__(String.capitalize(name))
      model.load(path)
    else
      Logger.error("#{@process} path=#{path} error=unknown_model")
    end
  end

  defp path_to_model_name(path) do
    path
    |> Path.basename()
    |> Path.extname()
    |> String.downcase()
    |> String.replace_leading(".", "")
    |> String.replace_trailing(".txt", "")
  end
end
