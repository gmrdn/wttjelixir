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
  
  def group_jobs_by_type_and_category(jobs) do
    jobs
    |> Enum.map(fn(x) -> 
      [Enum.at(x,0), Enum.at(x,1)]
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
  
  def replace_jobid_by_category(jobs, professions) do
    jobs
    |> Enum.map(fn(x) ->
      List.replace_at(x,0, get_category_by_job(professions, Enum.at(x, 0))) 
    end)
  end
  
  def count_jobs_by_type_and_category(jobs, professions) do
    jobs_replaced = replace_jobid_by_category(jobs,professions)
    group_jobs_by_type_and_category(jobs_replaced)
    |> Enum.map(fn {key, value} -> [Tuple.to_list(key), length(value)] end)
    |> Enum.sort()
    |> List.flatten()
    |> Enum.chunk_every(3)
    |> Enum.map(fn [a,b,c] -> {{a, b},c} end)
    |> Map.new()
  end

  def get_table_of_totals_from_csv() do
    jobs = map_csv(jobs_csv())
    professions = map_csv(professions_csv())
    count_jobs_by_type_and_category(jobs, professions)
  end

  def get_all_types(map_counters) do
    map_counters 
    |> Enum.group_by(fn {{a,_b},_c} -> a end) 
    |> Map.keys()
  end

  def get_all_categories(map_counters) do
    map_counters 
    |> Enum.group_by(fn {{_a,b},_c} -> b end) 
    |> Map.keys()
  end

  def format_headers(categories) do
    categories_display = format_categories(categories)
    display_horizontal_bar(16, categories_display)    
    IO.puts("|" <> String.duplicate(" ", 15) <> "| " <> Enum.join(categories_display, "| ") <> "|")
    display_horizontal_bar(16, categories_display)    
  end

  def format_categories(categories) do
    Enum.map(categories, fn(x) -> 
      x <> 
      if String.length(x) < 13 do
        String.duplicate(" ", 14 - String.length(x))
      else
        " "
      end 
    end)
  end

  def display_horizontal_bar(first_col_width, list_headers) do
    IO.puts(String.duplicate("-", first_col_width + (String.length(Enum.join(list_headers))) + 2 * length(list_headers)))
  end

  def format_body(types, categories, map_counters) do
    categories_display = format_categories(categories)

    Enum.each(types, fn(t) -> 
      row = "| " <> t <> String.duplicate(" ", 14 - String.length(t)) <> "|" <>
      Enum.map_join(categories, fn(c) ->
        total = Map.get(map_counters,{t,c})
        " " <> 
        if !!total do
          Integer.to_string(total) <> 
          String.duplicate(" ", if(String.length(c) < 13, do: 14, else: String.length(c) + 1) - String.length(Integer.to_string(total))) 
        else
          "0" <> String.duplicate(" ", if(String.length(c) < 13, do: 14, else: String.length(c) + 1 ) - 1)
        end
        <> "|"
      end)
      IO.puts(row)
      display_horizontal_bar(16, categories_display)    
    end)
  end

  def display_counts_by_categories_and_type_from_csv() do
    map_counters = get_table_of_totals_from_csv()
    types = get_all_types(map_counters)
    categories = get_all_categories(map_counters)
    format_headers(categories)
    format_body(types, categories, map_counters)
  end

end
