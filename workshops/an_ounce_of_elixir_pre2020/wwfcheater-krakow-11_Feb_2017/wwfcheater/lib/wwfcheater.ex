defmodule Wwfcheater do
  def pick(tiles, word) do
    pick(tiles, word, '')
  end
  def pick(tiles, word, accumulator) when tiles == '' or word == '' do
    accumulator
  end
  def pick tiles, [ letter | rest ], accumulator do
    cond do
        Enum.member?(tiles, letter) ->
          pick(tiles -- [ letter ], rest, accumulator ++ [ letter ])
        true ->
          pick(tiles, rest, accumulator)
    end
  end
end
