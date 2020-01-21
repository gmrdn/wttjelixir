defmodule WttjelixirTest do
  use ExUnit.Case
  doctest Wttjelixir

  test "greets the world" do
    assert Wttjelixir.hello() == :world
  end

  test "reads csv and return a non empty list of jobs" do
    assert length(Wttjelixir.mapcsv()) > 0
  end
end
