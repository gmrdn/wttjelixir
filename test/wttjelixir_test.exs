defmodule WttjelixirTest do
  use ExUnit.Case
  doctest Wttjelixir

  test "greets the world" do
    assert Wttjelixir.hello() == :world
  end

  test "reads the csv and returns the list of jobs" do
    assert length(Wttjelixir.mapcsvjobs()) == 5070
    assert Enum.at(Wttjelixir.mapcsvjobs(), 0) == ["7", "INTERNSHIP", "[Louis Vuitton Germany] Praktikant (m/w) im Bereich Digital Retail (E-Commerce)", "48.1392154", "11.5781413"]
  end

  test "counts nb jobs for id 22" do
    assert Wttjelixir.countjobsbyid("22") == 30
  end
end
