defmodule Pick do
  def pick(tiles, word) do
    pick(tiles, word, '')
  end
  def pick(tiles, word, accumulator) when tiles == '' or word == '' do
    accumulator
  end
  def pick(tiles, [ char | chars ], accumulator) do
    cond do
      Enum.member?(tiles, char) ->
        pick(tiles -- [char], chars, accumulator ++ [char])
      true ->
        pick(tiles, chars, accumulator)
    end
  end
end

# This is a comment
