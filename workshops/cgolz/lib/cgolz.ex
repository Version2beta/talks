defmodule Cgolz do
  @type campsite :: {integer, integer}
  @type campground :: [campsite]
  @type site_census :: {campsite, integer}
  @type census :: [site_census]

  @spec check_site(campground, campsite) :: :zombie | :brains
  def check_site(campground, campsite) do
    campsite in campground && :zombie || :brains
  end

  @neighbors [
    {-1, -1}, {0, -1}, {1, -1},
    {-1,  0},          {1,  0},
    {-1,  1}, {0,  1}, {1,  1}
  ]

  @spec find_neighbors(campsite) :: [campsite]
  def find_neighbors({x, y} = _campsite) do
    Enum.map(@neighbors, fn {x_offset, y_offset} -> {x + x_offset, y + y_offset} end)
  end

  @spec count_neighbors(campground, campsite) :: site_census
  def count_neighbors(campground, campsite) do
    neighbor_count = 
      find_neighbors(campsite)
      |> Enum.filter(fn site -> check_site(campground, site) == :zombie end)
      |> Enum.count()

    {campsite, neighbor_count}
  end

  @spec take_census(campground) :: census
  def take_census(campground) do
    Enum.flat_map(campground, fn campsite -> find_neighbors(campsite) end)
    |> Enum.uniq()
    |> Enum.map(fn campsite -> count_neighbors(campground, campsite) end)
  end

  @spec check_census(census, campsite) :: integer
  def check_census(census, campsite) do
    {_, count} = Enum.find(census, {campsite, 0}, fn {site, _} -> site == campsite end)
    count
  end

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
end

defmodule Cgolz.Helpers do
  @spec random_campground(x :: integer, y :: integer, density :: float) :: Cgolz.campground
  def random_campground(x, y, density \\ 0.25) do
    for xx <- 0..x, yy <- 0..y do
      :rand.uniform() < density && {xx, yy}
    end
    |> Enum.filter(fn el -> el end)
  end
end

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
