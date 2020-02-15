defmodule CgolzTest.HelperTest do
  use ExUnit.Case
  import Cgolz.Helper

  test "random_town returns a town, listing 0 or more valid plots" do
    width = :rand.uniform(100)
    depth = :rand.uniform(100)
    probability = :rand.uniform()

    town = random_town(width, depth, probability)
    assert Enum.count(town) >= 0
    assert Enum.count(town) <= width * depth

    Enum.each(
      town,
      fn {x, y} -> assert x <= width && y <= depth end
    )
  end

  test "a probability of zero results in an empty town" do
    town = random_town(10, 10, 0.00)
    assert town == []
  end

  test "a probability of one results in a full town" do
    town = random_town(10, 10, 1.00)
    assert Enum.count(town) == 100
  end
end
