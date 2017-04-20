defmodule Cart do
  @moduledoc """
  Documentation for Cart.
  """

  def contentReducer({:add, what, _when}, acc) do
    [ what | acc ]
  end

  def contentReducer({:remove, what, _when}, acc) do
    acc |> List.delete(what)
  end

  def contents(events) do
    events |>
    Enum.reduce([], &contentReducer/2) |>
    Enum.sort
  end
end
