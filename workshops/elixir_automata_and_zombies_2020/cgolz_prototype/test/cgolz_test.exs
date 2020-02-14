defmodule CgolzTest do
  use ExUnit.Case
  import Cgolz
  import Cgolz.Helpers, only: [random_town: 2]

  test "check_plot returns :zombie is the plot is listed in a town, :brains if not" do
    infected_town = for x <- 0..4, y <- 0..4, do: {x, y}
    Enum.each(infected_town, fn plot -> assert check_plot(infected_town, plot) == :zombie end)

    Enum.each(infected_town, fn {x, y} ->
      assert check_plot(infected_town, {x + 5, y + 5}) == :brains
    end)
  end

  test "find_neighbors returns appropriate plots" do
    {x, y} = random_plot = {:rand.uniform(100), :rand.uniform(100)}
    neighbors = find_neighbors(random_plot)
    assert Enum.min(neighbors) == {x - 1, y - 1}
    assert Enum.max(neighbors) == {x + 1, y + 1}
    assert Enum.count(neighbors) == 9
  end

  test "count_neighbors returns returns correct counts as a plot_census type" do
    random_plot = {:rand.uniform(100), :rand.uniform(100)}
    neighbors = find_neighbors(random_plot)
    assert count_neighbors([], random_plot) == {random_plot, 0}
    assert count_neighbors(neighbors, random_plot) == {random_plot, 9}
  end

  test "take_census returns the correct counts as a census type" do
    random_town = random_town(:rand.uniform(100), :rand.uniform(100))
    census = take_census(random_town)
    if Enum.count(random_town) > 0, do: assert(Enum.count(census) > 0)
    census_plots = Enum.map(census, fn {plot, _} -> plot end)

    Enum.each(
      random_town,
      fn plot ->
        assert plot in census_plots
        Enum.each(find_neighbors(plot), fn neighbor -> assert neighbor in census_plots end)
      end
    )

    uninfected_plots = Enum.filter(census_plots, fn {plot, _} -> plot not in random_town end)

    Enum.each(
      uninfected_plots,
      fn plot ->
        {_, count} = Enum.find(census, fn {p, _} -> p == plot end)
        assert count > 0
      end
    )

    neighborless_plots =
      Enum.filter(census, fn {_, count} -> count == 0 end)
      |> Enum.map(fn {plot, _} -> plot end)

    Enum.each(neighborless_plots, fn p -> assert p in random_town end)
  end

  test "Get the count from a census" do
    census =
      random_town(:rand.uniform(100), :rand.uniform(100))
      |> take_census()

    Enum.each(census, fn {plot, count} -> assert Cgolz.check_census(census, plot) == count end)
  end

  # 1. Any zombie with fewer than two neighboring zombies is overcome by the neighbors.
  # 2. Any zombie with two or three neighboring zombies goes on the to next tick.
  # 3. Any zombie with more than three zombie neighbours succombs to overpopulation.
  # 4. Any home with exactly three zombie neighbours remains, or becomes, zombified.

  test "Advancing one generation respects rule 1" do
    town =
      ({0, 0}
       |> find_neighbors()
       |> Enum.reject(fn e -> e == {0, 0} end)
       |> Enum.shuffle()
       |> Enum.take(Enum.random([0, 1]))) ++ [{0, 0}]

    assert {0, 0} not in tick(town)
  end

  test "Advancing one generation respects rule 2" do
    town =
      ({0, 0}
       |> find_neighbors()
       |> Enum.reject(fn e -> e == {0, 0} end)
       |> Enum.shuffle()
       |> Enum.take(Enum.random([2, 3]))) ++ [{0, 0}]

    assert {0, 0} in tick(town)
  end

  test "Advancing one generation respects rule 3" do
    town =
      ({0, 0}
       |> find_neighbors()
       |> Enum.reject(fn e -> e == {0, 0} end)
       |> Enum.shuffle()
       |> Enum.take(Enum.random([4, 8]))) ++ [{0, 0}]

    assert {0, 0} not in tick(town)
  end

  test "Advancing one generation respects rule 4" do
    town =
      {0, 0}
      |> find_neighbors()
      |> Enum.reject(fn e -> e == {0, 0} end)
      |> Enum.shuffle()
      |> Enum.take(3)

    assert {0, 0} in tick(town)
    assert {0, 0} in tick([{0, 0} | town])
  end
end
