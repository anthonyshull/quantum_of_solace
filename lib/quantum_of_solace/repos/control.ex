defmodule QuantumOfSolace.Repos.Control do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres, otp_app: :quantum_of_solace

  @repos %{
    blue: QuantumOfSolace.Repos.Blue,
    green: QuantumOfSolace.Repos.Green
  }

  def get_active_repo() do
    default_repo = Map.get(@repos, :blue)

    case query("SELECT canaries.to FROM canaries ORDER BY datetime DESC LIMIT 1") do
      {:ok, %Postgrex.Result{num_rows: 0}} ->
        Application.get_env(:quantum_of_solace, :active_repo, default_repo)

      {:ok, %Postgrex.Result{} = result} ->
        result_to_repo(result)

      _ ->
        Application.get_env(:quantum_of_solace, :active_repo, default_repo)
    end
  end

  def get_passive_repo() do
    @repos
    |> Map.values()
    |> Enum.find(&(&1 != get_active_repo()))
  end

  def last_modified() do
    query("SELECT datetime FROM canaries ORDER BY datetime DESC LIMIT 1")
    |> case do
      {:ok, %Postgrex.Result{num_rows: 0}} -> Timex.now() |> Timex.shift(years: -1)
      {:ok, %Postgrex.Result{} = result} -> result |> result_to_datetime()
      _ -> Timex.now() |> Timex.shift(years: -1)
    end
  end

  def set_active_repo() do
    Application.put_env(:quantum_of_solace, :active_repo, get_active_repo())
  end

  def set_active_repo(repo) do
    case query(
           "INSERT INTO canaries (\"from\", \"to\") VALUES ('#{get_active_repo()}', '#{repo}')"
         ) do
      {:ok, _} -> set_active_repo()
      _ -> :error
    end
  end

  def switch_active_repo() do
    get_passive_repo() |> set_active_repo()
  end

  defp result_to_datetime(result) do
    result
    |> Map.get(:rows)
    |> List.first()
    |> List.first()
    |> Timex.to_datetime("America/New_York")
  end

  defp result_to_repo(result) do
    result
    |> Map.get(:rows)
    |> List.first()
    |> List.first()
    |> String.to_atom()
  end
end
