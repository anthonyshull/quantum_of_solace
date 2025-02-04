defmodule QuantumOfSolace.Repos.Control do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres, otp_app: :quantum_of_solace

  @repos %{
    blue: QuantumOfSolace.Repos.Blue,
    green: QuantumOfSolace.Repos.Green
  }

  def consumer_run_active?(id) do
    case query("SELECT * FROM consumer_runs WHERE id=#{id} AND success IS NULL") do
      {:ok, %Postgrex.Result{num_rows: 1}} -> true
      _ -> false
    end
  end

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

  def get_last_modified(agency) do
    query("SELECT datetime FROM consumer_runs WHERE agency='#{agency}' AND success=TRUE ORDER BY datetime DESC LIMIT 1")
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

  def start_consumer_run(agency) do
    case query(
      "INSERT INTO consumer_runs (agency) VALUES ('#{agency}') RETURNING id"
    ) do
      {:ok, result} -> result_to_id(result)
      _ -> :error
    end
  end

  def stop_consumer_run(id, success) do
    query(
      "UPDATE consumer_runs SET success=#{success} WHERE id=#{id}"
    )
  end

  def switch_active_repo() do
    get_passive_repo() |> set_active_repo()
  end

  defp result_to_datetime(result) do
    result
    |> result_to_value()
    |> Timex.to_datetime("America/New_York")
  end

  defp result_to_id(result) do
    result_to_value(result)
  end

  defp result_to_repo(result) do
    result
    |> result_to_value()
    |> String.to_atom()
  end

  defp result_to_value(result) do
    result
    |> Map.get(:rows)
    |> List.first()
    |> List.first()
  end
end
