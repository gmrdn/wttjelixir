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

  def display_headers(categories) do
    categories_display = format_categories(categories)
    display_horizontal_bar(20, categories_display)    
    IO.puts("|" <> String.duplicate(" ", 19) <> "| Total         | " <> Enum.join(categories_display, "| ") <> "|")
    display_horizontal_bar(20, categories_display)    
  end

  def display_total_by_categories(categories, map_counters) do
    categories_display = format_categories(categories)
    total = Integer.to_string(Enum.sum(Enum.map(map_counters, fn {{_a,_b},c} -> c end)))
    row = "| TOTAL             | " <> total
    <> add_spaces(total, 14) <> "|" <>
    Enum.map_join(categories, fn(category) ->
      total_cat = Integer.to_string(Enum.sum(Enum.map(map_counters, fn {{_a,b},c} -> if(b == category, do: c, else: 0) end)))
      " " <> total_cat <> add_spaces(total_cat, if(String.length(category) < 13, do: 14, else: String.length(category) + 1))
      <> "|"
    end)
    IO.puts(row)
    display_horizontal_bar(20, categories_display)    
  end

  def format_categories(categories) do
    Enum.map(categories, fn(x) -> 
      if x == "" do
        "N/A" <> add_spaces("N/A", 14)
      else
        x <> add_spaces(x, 14)
      end    
    end)
  end

  def add_spaces(value, col_width) do 
    if String.length(value) < col_width do
      String.duplicate(" ", col_width - String.length(value))
    else
      " "
    end 
  end
  def display_horizontal_bar(first_col_width, list_headers) do
    IO.puts(String.duplicate("-", first_col_width + 16 + (String.length(Enum.join(list_headers))) + 2 * length(list_headers)))
  end

  def format_type(first_col_width, type) do 
    "| " <> type <> add_spaces(type, first_col_width - 2) <> "| "
  end

  def display_body(types, categories, map_counters) do
    categories_display = format_categories(categories)

    Enum.each(types, fn(type) -> 
      total_for_type = Integer.to_string(Enum.sum(Enum.map(map_counters, fn {{a,_b},c} -> if(a == type, do: c, else: 0) end))) 
      row = format_type(20, type)
      <> total_for_type
      <> add_spaces(total_for_type, 14) <> "|" <> 
      
      Enum.map_join(categories, fn(c) ->
        nb_jobs_for_category_and_type = Map.get(map_counters,{type,c})
        " " <> 
        if !!nb_jobs_for_category_and_type do
          Integer.to_string(nb_jobs_for_category_and_type) <> 
          add_spaces(Integer.to_string(nb_jobs_for_category_and_type), if(String.length(c) < 13, do: 14, else: String.length(c) + 1))
        else
          "0" <> add_spaces("0", if(String.length(c) < 13, do: 14, else: String.length(c) + 1 ))
        end
        <> "|"
      end)

      IO.puts(row)
      display_horizontal_bar(20, categories_display)    
    end)
  end

  def display_counts_by_categories_and_type_from_csv() do
    map_counters = get_table_of_totals_from_csv()
    types = get_all_types(map_counters)
    categories = get_all_categories(map_counters)
    display_headers(categories)
    display_total_by_categories(categories, map_counters)
    display_body(types, categories, map_counters)
  end

end
