defmodule WttjelixirTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  doctest Wttjelixir

  test "greets the world" do
    assert Wttjelixir.hello() == :world
  end

  test "reads the csv and returns the list of jobs" do
    jobs = Wttjelixir.map_csv(Wttjelixir.jobs_csv())
    assert length(jobs) >= 1
    assert is_list(Enum.at(jobs, 0)) #["7", "INTERNSHIP", "[Louis Vuitton Germany] Praktikant (m/w) im Bereich Digital Retail (E-Commerce)", "48.1392154", "11.5781413"]
  end
  
  test "counts nb jobs for a given id" do
    jobs = Wttjelixir.map_csv(Wttjelixir.jobs_csv())
    assert Wttjelixir.count_jobs_by_id(jobs, "22") >= 1
  end

  test "counts zero jobs for an unknown job id" do
    jobs = Wttjelixir.map_csv(Wttjelixir.jobs_csv())
    assert Wttjelixir.count_jobs_by_id(jobs, "AAA") == 0
  end

  test "reads the csv and returns the list of professions" do
    professions = Wttjelixir.map_csv(Wttjelixir.professions_csv())
    assert length(professions) >= 1
    assert is_list(Enum.at(professions, 0)) #["17","Devops / Infrastructure","Tech"]
  end

  test "groups jobs by type of contract" do
    jobs = Wttjelixir.map_csv(Wttjelixir.jobs_csv())
    assert length(Map.fetch!(Wttjelixir.group_jobs_by_type(jobs), "APPRENTICESHIP"))  >= 1
  end

  test "displays the sum of job by type of contract" do
    jobs = Wttjelixir.map_csv(Wttjelixir.jobs_csv())
    assert capture_io(fn ->
      Wttjelixir.output_nb_job_by_category(jobs)
    end) == """
    APPRENTICESHIP: 423
    FREELANCE: 38
    FULL_TIME: 3091
    INTERNSHIP: 1292
    PART_TIME: 4
    TEMPORARY: 211
    VIE: 10
    """
  end
  
  test "matches a job category for a given job" do
    professions = Wttjelixir.map_csv(Wttjelixir.professions_csv())
    assert Wttjelixir.get_category_by_job(professions, "17") == "Tech"
  end

  test "remplace le job id par sa categorie" do
    jobs = Wttjelixir.map_csv(Wttjelixir.jobs_csv())
    professions = Wttjelixir.map_csv(Wttjelixir.professions_csv())
    assert List.first(Enum.at(Wttjelixir.replace_jobid_by_category(jobs,professions),0)) == "Marketing / Comm'"
  end


end
