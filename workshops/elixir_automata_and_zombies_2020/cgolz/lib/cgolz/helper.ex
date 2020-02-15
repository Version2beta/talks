defmodule Cgolz.Helper do
  @spec random_town(integer, integer, Float.t()) :: Cgolz.town()
  def random_town(width, depth, probability \\ 0.25)
      when is_integer(width) and is_integer(depth) and is_float(probability) do
    for x <- 1..width, y <- 1..depth do
      :rand.uniform() <= probability && {x, y}
    end
    |> Enum.filter(fn el -> el end)
  end
end
