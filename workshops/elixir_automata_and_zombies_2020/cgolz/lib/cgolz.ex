defmodule Cgolz do
  @type plot :: {integer, integer}
  @type town :: [plot]
  @type plot_census :: {plot, integer}
  @type census :: [plot_census]

  @spec check_plot(town(), plot()) :: :zombie | :brains
  def check_plot(town, plot) do
    (plot in town && :zombie) || :brains
    # case plot in town do
    #   false -> :brains
    #   true -> :zombie
    # end
    # if plot in town, do: :zombie, else: :brains
    # cond do
    #   plot in town -> :zombie
    #   true -> :brains
    # end
  end

  # def check_plot(town, plot) when plot in town, do: :zombie
  # def check_plot(_, _), do: :brains

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
    Enum.map(
      @neighbors,
      fn {x_offset, y_offset} -> {x + x_offset, y + y_offset} end
    )
  end
end
