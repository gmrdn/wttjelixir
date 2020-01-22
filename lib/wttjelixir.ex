defmodule Wttjelixir do
  
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
  
  def group_jobs_by_type_and_category(joblist) do
    joblist
    |> Enum.map(fn(x) -> 
      [List.first(x), Enum.at(x,1)]
    end)
    |> Enum.group_by(fn(x) -> 
      {Enum.at(x,1), Enum.at(x,0)}
    end)
  end

  def get_category_by_job(professions, job_id) do 
    professions
    |> Enum.filter(fn(x) ->
      Enum.at(x,0) == job_id
    end)
    |> List.last()
    |> List.last()
  end
  
  def replace_jobid_by_category(joblist, professions) do
    joblist
    |> Enum.map(fn(x) ->
      List.replace_at(x,0, get_category_by_job(professions, Enum.at(x, 0))) 
    end)
  end
  
  def count_jobs_by_type_and_category(jobs, professions) do
    jobs_replaced = replace_jobid_by_category(jobs,professions)
    map_grouped = group_jobs_by_type_and_category(jobs_replaced)
    
    Enum.sort(Enum.map(map_grouped, fn ({key, value}) ->   
      [Tuple.to_list(key), length(value)] 
    end))
  end
  
end
