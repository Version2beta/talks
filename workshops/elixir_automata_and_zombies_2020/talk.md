# Conway's Game of Zombie Summercamp

Slide for talk, sponsors
Discuss deaf developers while waiting?

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
defmodule Cgolz.Helpers do
  @spec random_town(x :: integer, y :: integer, density :: float) :: Cgolz.town
  def random_town(x, y, density) do
    for xx <- 0..x, yy <- 0..y do
      :rand.uniform() < density && {xx, yy}
    end
    |> Enum.filter(fn el -> el end)
  end
end
```

in iex:

```
recompile
Cgolz.Helpers.random_town(8, 8)
Cgolz.Helpers.random_town(8, 8, 0.5)
Cgolz.Helpers.random_town(8, 8, 1)
town = Cgolz.Helpers.random_town(8, 8)
```

### Check a plot

```
@spec check_plot(town, plot) :: :zombie | :brains
def check_plot(town, plot) do
  plot in town && :zombie || :brains
end
```

in iex:

```
recompile
Cgolz.check_plot(town, {1, 1})
Cgolz.check_plot(town, {1, 2})
```

### Find the coordinates of all neighbors to a plot

```
@neighbors [
  {-1, -1}, {0, -1}, {1, -1},
  {-1,  0},          {1,  0},
  {-1,  1}, {0,  1}, {1,  1}
]

@spec find_neighbors(plot) :: [plot]
def find_neighbors({x, y} = _plot) do
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
@spec count_neighbors(town, plot) :: plot_census
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
@spec take_census(town) :: census
def take_census(town) do
  Enum.flat_map(town, fn plot -> find_neighbors(plot) end)
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
@spec check_census(town, plot) :: integer()
def check_census(town, plot) do
  {_, count} = Enum.find(town, {plot, 0}, fn {site, _} -> site == plot end)
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
town = Cgolz.Helpers.random_town(8,8,0.4)
Cgolz.Render.render_town(town) |> IO.puts
Cgolz.tick(town)
Cgolz.Render.render_town(v()) |> IO.puts
Cgolz.run(town)
Cgolz.run(town, generations: 25)
Cgolz.run(town, generations: 25, wait: 250)
```
