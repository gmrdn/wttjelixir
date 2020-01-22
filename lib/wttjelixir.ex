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


  def mapcsvjobs do
    File.read!("data/technical-test-jobs.csv")
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ","))
    |> Enum.drop(1)
  end

  def countjobsbyid(jobid) do
    mapcsvjobs()
    |> Enum.count(&(Enum.at(&1,0)  =~ jobid))
  end
end
