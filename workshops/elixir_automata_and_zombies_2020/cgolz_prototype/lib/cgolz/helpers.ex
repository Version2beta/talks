defmodule Cgolz.Helpers do
  @spec random_town(integer, integer, Float.t()) :: Cgolz.town()
  def random_town(width, depth, probability \\ 0.25) do
    for x <- 1..width, y <- 1..depth do
      :rand.uniform() < probability && {x, y}
    end
    |> Enum.filter(fn el -> el end)
  end

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
      "The humans fend of the zombies!"
    else
      _ ->
        "The zombies eat well!"
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
      &((Cgolz.check_plot(&1, &2) == :zombie && "🧟 ") || "  ")
      # &((Cgolz.check_plot(&1, &2) == :zombie && "🧟 ") || "🧠 ")
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
