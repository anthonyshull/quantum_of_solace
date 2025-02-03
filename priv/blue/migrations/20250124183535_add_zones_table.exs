defmodule QuantumOfSolace.Repos.Migrations.AddZonesTable do
  @moduledoc """
  """

  alias QuantumOfSolace.Models.Station

  use Ecto.Migration

  def up do
    create table("zones", primary_key: false) do
      add(:agency, :string, primary_key: true)
      add(:id, :string, primary_key: true)
    end
  end

  def down do
    drop table("zones")
  end
end
