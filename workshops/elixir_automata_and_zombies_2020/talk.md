# Conway's Game of Zombie Summercamp

Slide for talk, sponsors
Discuss deaf developers while waiting?

## Concepts:

History:

* Last year's A gentle introduction to functional programming with Elixir
* Global Day of Code Retreat
* Conway's Game of Life
* Fun with variations
* Conway's Game of Zombie Summer Camp

Objectives:

* Almost entirely code
* Create a new project in Elixir
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
* Solve Conway's Game of Life, or at least Zombie Summer Camp
* Run it through a render program I wrote. If there's time, we can look at that too.

Rules for Conway's Game of Life:

A zero player cellular automata game, played on a grid of any size fixed or growing

1. Any live cell with fewer than two live neighbours dies, as if by underpopulation.
2. Any live cell with two or three live neighbours lives on to the next generation.
3. Any live cell with more than three live neighbours dies, as if by overpopulation.
4. Any dead cell with three live neighbours becomes a live cell, as if by reproduction.

Rules for Conway's Game of Zombie Summer Camp

1. Any zombie with fewer than two neighboring zombies is overcome by the campers.
2. Any zombie with two or three neighboring zombies goes on the to next tick.
3. Any zombie with more than three zombie neighbours succombs to overpopulation.
4. Any campsite with exactly three zombie neighbours remains, or becomes, zombified.

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
  @type campsite :: {integer, integer}
  @type campground :: [campsite]
  @type site_census :: {campsite, integer}
  @type census :: [site_census]


end
```

### Fake some data

```
defmodule Cgolz.Helpers do
  @spec random_campground(x :: integer, y :: integer, density :: float) :: Cgolz.campground
  def random_campground(x, y, density) do
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
Cgolz.Helpers.random_campground(8, 8)
Cgolz.Helpers.random_campground(8, 8, 0.5)
Cgolz.Helpers.random_campground(8, 8, 1)
camp = Cgolz.Helpers.random_campground(8, 8)
```

### Check a campsite

```
@spec check_site(campground, campsite) :: :zombie | :brains
def check_site(campground, campsite) do
  campsite in campground && :zombie || :brains
end
```

in iex:

```
recompile
Cgolz.check_site(camp, {1, 1})
Cgolz.check_site(camp, {1, 2})
```

### Find the coordinates of all neighbors to a campsite

```
@neighbors [
  {-1, -1}, {0, -1}, {1, -1},
  {-1,  0},          {1,  0},
  {-1,  1}, {0,  1}, {1,  1}
]

@spec find_neighbors(campsite) :: [campsite]
def find_neighbors({x, y} = _campsite) do
  Enum.map(@neighbors, fn {x_offset, y_offset} -> {x + x_offset, y + y_offset} end)
end
```

in iex:

```
recompile
Cgolz.find_neighbors({1,1})
Cgolz.find_neighbors({4,4})
```

### Count all of the neighbors to a campsite

```
@spec count_neighbors(campground, campsite) :: site_census
def count_neighbors(campground, campsite) do
  neighbors_count =
    find_neighbors(campsite)
    |> Enum.filter(fn site -> check_site(campground, site) == :zombie end)
    |> Enum.count()

  {campsite, neighbors_count}
end
```

in iex:

```
recompile
Cgolz.count_neighbors(camp, {4,4})
```

### Take a census of the entire campground

```
@spec take_census(campground) :: census
def take_census(campground) do
  Enum.flat_map(campground, fn campsite -> find_neighbors(campsite) end)
  |> Enum.uniq()
  |> Enum.map(fn campsite -> count_neighbors(campground, campsite) end)
end
```

in iex:

```
recompile
census = Cgolz.take_census(camp)
```

### Reference a census

```
@spec check_census(campground, campsite) :: integer()
def check_census(campground, campsite) do
  {_, count} = Enum.find(campground, {campsite, 0}, fn {site, _} -> site == campsite end)
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
@spec tick(campground) :: campground
def tick(campground) do
  take_census(campground)
  |> Enum.reduce([], fn {campsite, count}, acc ->
    cond do
      count == 2 and campsite in campground -> [campsite | acc]
      count == 3 -> [campsite | acc]
      true -> acc
    end
  end)
  |> Enum.sort()
end
```

### Rendering
```
defmodule Cgolz.Render do
  def run(campground, opts \\ []) do
    {{min_x1, min_y1}, {max_x1, max_y1}} = range_finder(campground)
    IO.ANSI.clear() |> IO.write()

    final_campground =
      Enum.reduce(
        1..Keyword.get(opts, :generations, 10),
        {campground, {{min_x1, min_y1}, {max_x1, max_y1}}},
        fn g, {current, {{min_x, min_y}, {max_x, max_y}}} ->
          IO.ANSI.home() |> IO.write()
          IO.puts("Generation #{g} - #{max_x - min_x + 1} x #{max_y - min_y + 1}")

          render_campground(current, {{min_x, min_y}, {max_x, max_y}})
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

    with {[], _} <- final_campground do
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

  def render_campground(campground, size \\ nil) do
    render(
      campground,
      size || range_finder(campground),
      &((Cgolz.check_site(&1, &2) == :zombie && "🧟 ") || "🧠 ")
    )
  end

  def render_census(campground) do
    Cgolz.take_census(campground)
    |> render(&Cgolz.check_census/2)
  end

  def range_finder([{{_, _}, _} | _] = census) do
    Enum.map(census, fn {{x, y}, _count} -> {x, y} end)
    |> range_finder()
  end

  def range_finder([h | _] = campground) do
    Enum.reduce(campground, {h, h}, fn {x, y}, {{min_x, min_y}, {max_x, max_y}} ->
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
camp = Cgolz.Helpers.random_camp(8,8,0.4)
Cgolz.Render.render_campground(camp) |> IO.puts
Cgolz.tick(camp)
Cgolz.Render.render_campground(v()) |> IO.puts
Cgolz.run(camp)
Cgolz.run(camp, generations: 25)
Cgolz.run(camp, generations: 25, wait: 250)
```
