defmodule QuantumOfSolace.Repos.Control do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres, otp_app: :quantum_of_solace

  def consumer_run_active?() do
    case query("SELECT success FROM consumer_runs ORDER BY datetime LIMIT 1") do
      {:ok, %Postgrex.Result{rows: [[nil]]}} -> true
      _ -> false
    end
  end

  def consumer_run_active?(id) do
    case query("SELECT * FROM consumer_runs WHERE id=#{id} AND success IS NULL") do
      {:ok, %Postgrex.Result{num_rows: 1}} -> true
      _ -> false
    end
  end

  def get_last_modified(agency) do
    query(
      "SELECT datetime FROM consumer_runs WHERE agency='#{agency}' AND success=TRUE ORDER BY datetime DESC LIMIT 1"
    )
    |> case do
      {:ok, %Postgrex.Result{num_rows: 0}} -> Timex.now() |> Timex.shift(years: -1)
      {:ok, %Postgrex.Result{} = result} -> result |> result_to_datetime()
      _ -> Timex.now() |> Timex.shift(years: -1)
    end
  end

  def start_consumer_run(agency) do
    case query("INSERT INTO consumer_runs (agency) VALUES ('#{agency}') RETURNING id") do
      {:ok, result} -> result_to_id(result)
      _ -> :error
    end
  end

  def stop_consumer_run(id, success) do
    query("UPDATE consumer_runs SET success=#{success} WHERE id=#{id}")
  end

  defp result_to_datetime(result) do
    result
    |> result_to_value()
    |> Timex.to_datetime("America/New_York")
  end

  defp result_to_id(result) do
    result_to_value(result)
  end

  defp result_to_value(result) do
    result
    |> Map.get(:rows)
    |> List.first()
    |> List.first()
  end
end
