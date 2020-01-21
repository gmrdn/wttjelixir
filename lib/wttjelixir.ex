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


  def mapcsv do
    File.read!("data/technical-test-jobs.csv")
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ","))
  end
end
