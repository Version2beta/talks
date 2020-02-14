# Elixir, Automata, and Zombies

## Concepts:

History:

* Created by British mathematician John Horton Conway in 1970
* Requires only an initial or "seed" state and runs on its own from there
* The rules make for interesting, repeatable patterns that people have given names like "glider gun" and "puffer breeder"
* Solving Conway's Game of Life is the problem used during the Global Day of Code Retreat
* Fun with variations -
  * Fixed vs growing grid
  * Wrap around
  * Mobius strip
  * Globe
  * Not cells but homes and neighborhoods
  * Seed with population data, display on a map
* Conway's Game of Zombie Summer Camp at That Conference

Objectives:

* Expressions
* Atoms
* Tuples
* Lists
* Functions
* Modules
* Create a new project in Elixir
  * I'll be using Visual Studio Code
* Set up tests
* Basic data structures and optional types
* Working with lists and tuples (not the optimal approach)
* Type specs for functions (optional)
* Common functional programming patterns
    * Mostly pure functions and transformations
    * List comprehension for a cartesian product (with side effect)
    * Filter
    * Map
    * Pattern matching
    * Function composition
* Solve Conway's Game of Zombie Life
* Create a way to render it

How we'll do it:

* Start with some Elixir principals
* Set up our project
* Start coding as a big group
* Break into pairs or mobs
* Come back together at the end
  * Retrospective

Rules for Conway's Game of Life:

A zero player cellular automata game, played on a grid of any size fixed or growing

1. Any live cell with fewer than two live neighbours dies, as if by underpopulation.
2. Any live cell with two or three live neighbours lives on to the next generation.
3. Any live cell with more than three live neighbours dies, as if by overpopulation.
4. Any dead cell with three live neighbours becomes a live cell, as if by reproduction.

Rules for Conway's Game of Zombie Summer Camp

Assuming a neighborhood arranged on an orthogonal grid:

1. Any zombie with fewer than two neighboring zombies is overcome by the neighbors.
2. Any zombie with two or three neighboring zombies goes on the to next tick.
3. Any zombie with more than three zombie neighbours succombs to overpopulation.
4. Any home with exactly three zombie neighbours remains, or becomes, zombified.

## Our process

1. Create our project: `Cgolz`
2. Create our types: `plot`, `town`, `plot_census`, `census`
3. Fake some data: `Cgolz.Helpers.random_town()`
4. Check a plot: `Cgolz.check_plot()`
5. Find neighbors’ coordinates: `Cgolz.find_neighbors()`
6. Count how many are infected: `Cgolz.count_neighbors()`
7. Take a census of the entire town: `Cgolz.take_census()`
8. Reference that census: `Cgolz.check_census()`
9. Advance a generation: `Cgolz.tick()`
10. Render a map: `Cgolz.Helpers.render_town()`
11. Render multiple generations: `Cgolz.Helpers.run()`

### New project

```
mix new cgolz
cd cgolz
vi lib/cgolz.ex
```

in another shell:

```
iex -S mix
```

### Data types and structures

```
defmodule Cgolz do
  @type plot :: {integer, integer}
  @type town :: [plot]
  @type plot_census :: {plot, integer}
  @type census :: [plot_census]


end
```

### Fake some data

```
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

defmodule Cgolz.Helpers do
  @spec random_town(integer, integer, Float.t()) :: Cgolz.town()
  def random_town(width, depth, probability \\ 0.25) do
    for x <- 1..width, y <- 1..depth do
      :rand.uniform() < probability && {x, y}
    end
    |> Enum.filter(fn el -> el end)
  end
end
```

`iex -S mix`:

```
import Cgolz.Helpers
town = random_town(10, 10, 0.4)
```


### Check a plot

```
  test "check_plot returns :zombie is the plot is listed in a town, :brains if not" do
    infected_town = for x <- 0..4, y <- 0..4, do: {x, y}
    Enum.each(infected_town, fn plot -> assert check_plot(infected_town, plot) == :zombie end)

    Enum.each(infected_town, fn {x, y} ->
      assert check_plot(infected_town, {x + 5, y + 5}) == :brains
    end)
  end
```

```
  @spec check_plot(town(), plot()) :: :zombie | :brains
  def check_plot(town, plot) do
    (plot in town && :zombie) || :brains
  end
```

in iex:

```
recompile
import Cgolz
Cgolz.check_plot(town, {1, 1})
Cgolz.check_plot(town, {1, 2})
```

### Find the coordinates of all neighbors to a plot

```
  test "find_neighbors returns appropriate plots" do
    {x, y} = random_plot = {:rand.uniform(100), :rand.uniform(100)}
    neighbors = find_neighbors(random_plot)
    assert Enum.min(neighbors) == {x - 1, y - 1}
    assert Enum.max(neighbors) == {x + 1, y + 1}
    assert Enum.count(neighbors) == 8
  end
```

```
  @neighbors [
    {-1, -1}, {0, -1}, {1, -1},
    {-1,  0},          {1,  0},
    {-1,  1}, {0,  1}, {1,  1}
  ]

  @spec find_neighbors(plot) :: [plot]
  def find_neighbors({x, y}) do
    Enum.map(@neighbors, fn {x_offset, y_offset} -> {x + x_offset, y + y_offset} end)
  end
```

in iex:

```
recompile
Cgolz.find_neighbors({1,1})
Cgolz.find_neighbors({4,4})
```

### Count all of the neighbors to a plot

```
  test "count_neighbors returns returns correct counts as a plot_census type" do
    random_plot = {:rand.uniform(100), :rand.uniform(100)}
    neighbors = find_neighbors(random_plot)
    assert count_neighbors([], random_plot) == {random_plot, 0}
    assert count_neighbors(neighbors, random_plot) == {random_plot, 8}
  end
```

```
  @spec count_neighbors(town, plot) :: plot_census()
  def count_neighbors(town, plot) do
    neighbors_count =
      find_neighbors(plot)
      |> Enum.filter(fn site -> check_plot(town, site) == :zombie end)
      |> Enum.count()

    {plot, neighbors_count}
  end
```

in iex:

```
recompile
Cgolz.count_neighbors(town, {4,4})
```

### Take a census of the entire town

```
  test "take_census returns the correct counts as a census type" do
    random_town = random_town(:rand.uniform(10), :rand.uniform(10))
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

    uninfected_plots = Enum.filter(census_plots, fn plot -> plot not in random_town end)

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
```

```
  @spec take_census(town) :: census
  def take_census(town) do
    Enum.flat_map(town, fn plot -> [plot | find_neighbors(plot)] end)
    |> Enum.uniq()
    |> Enum.map(fn plot -> count_neighbors(town, plot) end)
  end
```

in iex:

```
recompile
census = Cgolz.take_census(town)
```

### Reference a census

```
  test "Get the count from a census" do
    census =
      random_town(:rand.uniform(100), :rand.uniform(100))
      |> take_census()

    Enum.each(census, fn {plot, count} -> assert Cgolz.check_census(census, plot) == count end)
  end
```

```
  @spec check_census(census, plot) :: integer
  def check_census(census, plot) do
    {_, count} = Enum.find(census, {plot, 0}, fn {site, _} -> site == plot end)
    count
  end
```

in iex:

```
recompile
Cgolz.check_census(census, {4,4})
```

### Tock tick

```
  # 1. Any zombie with fewer than two neighboring zombies is overcome by the neighbors.
  # 2. Any zombie with two or three neighboring zombies goes on the to next tick.
  # 3. Any zombie with more than three zombie neighbours succombs to overpopulation.
  # 4. Any home with exactly three zombie neighbours remains, or becomes, zombified.

  test "Advancing one generation respects rule 1" do
    town =
      ({0, 0}
       |> find_neighbors()
       |> Enum.shuffle()
       |> Enum.take(Enum.random([0, 1]))) ++ [{0, 0}]

    assert {0, 0} not in tick(town)
  end

  test "Advancing one generation respects rule 2" do
    town =
      ({0, 0}
       |> find_neighbors()
       |> Enum.shuffle()
       |> Enum.take(Enum.random([2, 3]))) ++ [{0, 0}]

    assert {0, 0} in tick(town)
  end

  test "Advancing one generation respects rule 3" do
    town =
      ({0, 0}
       |> find_neighbors()
       |> Enum.shuffle()
       |> Enum.take(Enum.random([4, 8]))) ++ [{0, 0}]

    assert {0, 0} not in tick(town)
  end

  test "Advancing one generation respects rule 4" do
    town =
      {0, 0}
      |> find_neighbors()
      |> Enum.shuffle()
      |> Enum.take(3)

    assert {0, 0} in tick(town)
    assert {0, 0} in tick([{0, 0} | town])
  end
```

```
  @spec tick(town) :: town
  def tick(town) do
    take_census(town)
    |> Enum.reduce([], fn {plot, count}, acc ->
      cond do
        count == 2 and plot in town -> [plot | acc]
        count == 3 -> [plot | acc]
        true -> acc
      end
    end)
    |> Enum.sort()
  end
```

### Rendering
```
defmodule Cgolz.Render do
  def run(town, opts \\ []) do
    {{min_x1, min_y1}, {max_x1, max_y1}} = range_finder(town)
    IO.ANSI.clear() |> IO.write()

    final_town =
      Enum.reduce(
        1..Keyword.get(opts, :generations, 10),
        {town, {{min_x1, min_y1}, {max_x1, max_y1}}},
        fn g, {current, {{min_x, min_y}, {max_x, max_y}}} ->
          IO.ANSI.home() |> IO.write()
          IO.puts("Generation #{g} - #{max_x - min_x + 1} x #{max_y - min_y + 1}")

          render_town(current, {{min_x, min_y}, {max_x, max_y}})
          |> IO.puts()

          :timer.sleep(Keyword.get(opts, :wait, 500))

          next = Cgolz.tick(current)
          {{new_min_x, new_min_y}, {new_max_x, new_max_y}} = range_finder(next)

          {
            next,
            {
              {min(new_min_x, min_x), min(new_min_y, min_y)},
              {max(new_max_x, max_x), max(new_max_y, max_y)}
            }
          }
        end
      )

    with {[], _} <- final_town do
      :smooooores!
    else
      _ ->
        :braaaaaaaains!
    end
  end

  def render(source, fun), do: render(source, range_finder(source), fun)

  def render(source, {{min_x, min_y}, {max_x, max_y}}, fun) do
    for y <- min_y..max_y do
      for x <- min_x..max_x do
        fun.(source, {x, y})
      end
      |> Enum.join("")
    end
    |> Enum.join("\n")
  end

  def render_town(town, size \\ nil) do
    render(
      town,
      size || range_finder(town),
      &((Cgolz.check_plot(&1, &2) == :zombie && "🧟 ") || "🧠 ")
    )
  end

  def render_census(town) do
    Cgolz.take_census(town)
    |> render(&Cgolz.check_census/2)
  end

  def range_finder([{{_, _}, _} | _] = census) do
    Enum.map(census, fn {{x, y}, _count} -> {x, y} end)
    |> range_finder()
  end

  def range_finder([h | _] = town) do
    Enum.reduce(town, {h, h}, fn {x, y}, {{min_x, min_y}, {max_x, max_y}} ->
      {
        {min(x, min_x), min(y, min_y)},
        {max(x, max_x), max(y, max_y)}
      }
    end)
  end

  def range_finder([]), do: {{0, 0}, {0, 0}}
end
```

in iex:

```
recompile
import Cgolz.Helpers
town = random_town(8,8,0.4)
Cgolz.run(town, generations: 25, wait: 250)
```
