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

  @filepath "data/"

  def professions_csv do
    @filepath <> "technical-test-professions.csv"
  end 

  def jobs_csv do
    @filepath <> "technical-test-jobs.csv"
  end

  def map_csv(filename) do
    File.read!(filename)
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ","))
    |> Enum.drop(1)
  end

  def count_jobs_by_id(joblist, jobid) do
    Enum.count(joblist, &(Enum.at(&1,0)  =~ jobid))
  end

  def group_jobs_by_type(joblist) do
    Enum.group_by(Enum.map(joblist, &([List.first(&1),Enum.at(&1,1)])), &(Enum.at(&1,1)))
  end

  def get_category_by_job(professions, job_id) do 
    List.last(List.last(Enum.filter(professions, fn(x) ->
       Enum.at(x,0)== job_id 
      end)))
  end

  def replace_jobid_by_category(joblist, professions) do
    Enum.map(joblist, fn(x) ->
      List.replace_at(x,0, Wttjelixir.get_category_by_job(professions, Enum.at(x, 0))) 
    end)
  end

  def output_nb_job_by_category(joblist) do
    map = Enum.group_by(Enum.map(joblist, &([List.first(&1),Enum.at(&1,1)])), &(Enum.at(&1,1)))
    Enum.each(map, fn ({key, value}) ->   
      IO.puts("#{key}: #{length(value)}") 
    end)
  end
end
