defmodule WttjelixirTest do
  use ExUnit.Case
  doctest Wttjelixir

  test "greets the world" do
    assert Wttjelixir.hello() == :world
  end

  test "reads the csv and returns the list of jobs" do
    assert length(Wttjelixir.map_csv(Wttjelixir.jobs_csv())) == 5070
    assert Enum.at(Wttjelixir.map_csv(Wttjelixir.jobs_csv()), 0) == ["7", "INTERNSHIP", "[Louis Vuitton Germany] Praktikant (m/w) im Bereich Digital Retail (E-Commerce)", "48.1392154", "11.5781413"]
  end

  test "counts nb jobs for a given id" do
    assert Wttjelixir.count_jobs_by_id("22") == 30
  end

  test "counts zero jobs for an unknown job id" do
    assert Wttjelixir.count_jobs_by_id("999") == 0
  end

  test "reads the csv and returns the list of professions" do
    assert length(Wttjelixir.map_csv(Wttjelixir.professions_csv())) == 42
    assert Enum.at(Wttjelixir.map_csv(Wttjelixir.professions_csv()), 0) == ["17","Devops / Infrastructure","Tech"]
  end


end
