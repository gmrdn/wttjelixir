defmodule Wttjelixir do
  @moduledoc """
  Documentation for Wttjelixir.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Wttjelixir.hello()
      :world

  """
  def hello do
    :world
  end

  def filepath do
    "data/"
  end

  def professions_csv do
    filepath() <> "technical-test-professions.csv"
  end
  
  def jobs_csv do
    filepath() <> "technical-test-jobs.csv"
  end

  def map_csv(filename) do
    File.read!(filename)
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ","))
    |> Enum.drop(1)
  end

  def count_jobs_by_id(jobid) do
    map_csv(jobs_csv())
    |> Enum.count(&(Enum.at(&1,0)  =~ jobid))
  end
end
