defmodule QuantumOfSolace.Repos.DynamicSupervisor do
  use DynamicSupervisor

  alias QuantumOfSolace.Repos.Control

  @repos [
    QuantumOfSolace.Repos.Blue,
    QuantumOfSolace.Repos.Green
  ]

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def active() do
    if child = child() do
      child |> elem(3) |> List.first()
    end
  end

  def active_pid() do
    if child = child() do
      child |> elem(1)
    end
  end

  def passive() do
    @repos
    |> Enum.reject(&(&1 == active()))
    |> List.first()
  end

  def switch() do
    database = passive() |> repo_to_database()

    Control.query("DROP DATABASE IF EXISTS #{database}")

    Control.query("CREATE DATABASE #{database} WITH TEMPLATE writer OWNER #{database}")

    DynamicSupervisor.start_child(__MODULE__, passive())

    DynamicSupervisor.terminate_child(__MODULE__, active_pid())
  end

  defp child() do
    __MODULE__
    |> DynamicSupervisor.which_children()
    |> Enum.find(fn child ->
      (child |> elem(3) |> List.first()) in @repos
    end)
  end

  defp repo_to_database(repo) do
    repo
    |> Atom.to_string()
    |> String.split(".")
    |> List.last()
    |> String.downcase()
  end
end
