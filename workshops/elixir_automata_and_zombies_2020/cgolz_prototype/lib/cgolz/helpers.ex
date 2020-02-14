defmodule Cgolz.Helpers do
  @spec random_town(integer, integer, Float.t()) :: Cgolz.town()
  def random_town(width, depth, probability \\ 0.25) do
    for x <- 1..width, y <- 1..depth do
      :rand.uniform() < probability && {x, y}
    end
    |> Enum.filter(fn el -> el end)
  end
end
