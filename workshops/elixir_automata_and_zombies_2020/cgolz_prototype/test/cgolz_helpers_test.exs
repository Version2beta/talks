defmodule CgolzTest.HelpersTest do
  use ExUnit.Case
  import Cgolz.Helpers

  test "random_town returns a town, listing 0 or more valid plots" do
    width = :rand.uniform(100)
    depth = :rand.uniform(100)
    probability = :rand.uniform()

    town = random_town(width, depth, probability)
    assert Enum.count(town) >= 0
    assert Enum.count(town) <= width * depth

    Enum.each(town, fn {x, y} -> assert x <= width && y <= depth end)
  end
end
