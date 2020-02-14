defmodule Cgolz do
  @moduledoc """
  Documentation for Cgolz.
  """
  @type plot :: {integer, integer}
  @type town :: [plot]
  @type plot_census :: {plot, integer}
  @type census :: [plot_census]

  @spec check_plot(town(), plot()) :: :zombie | :brains
  def check_plot(town, plot) do
    (plot in town && :zombie) || :brains
  end

  @neighbors [
    {-1, -1},
    {0, -1},
    {1, -1},
    {-1, 0},
    {1, 0},
    {-1, 1},
    {0, 1},
    {1, 1}
  ]

  @spec find_neighbors(plot) :: [plot]
  def find_neighbors({x, y}) do
    Enum.map(@neighbors, fn {x_offset, y_offset} -> {x + x_offset, y + y_offset} end)
  end

  @spec count_neighbors(town, plot) :: plot_census()
  def count_neighbors(town, plot) do
    neighbors_count =
      find_neighbors(plot)
      |> Enum.filter(fn site -> check_plot(town, site) == :zombie end)
      |> Enum.count()

    {plot, neighbors_count}
  end

  @spec take_census(town) :: census
  def take_census(town) do
    Enum.flat_map(town, fn plot -> [plot | find_neighbors(plot)] end)
    |> Enum.uniq()
    |> Enum.map(fn plot -> count_neighbors(town, plot) end)
  end

  @spec check_census(census, plot) :: integer
  def check_census(census, plot) do
    {_, count} = Enum.find(census, {plot, 0}, fn {site, _} -> site == plot end)
    count
  end

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
end
