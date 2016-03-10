defmodule Cheat do
  def matches?(tiles, word) do
    MapSet.new(word) == MapSet.intersection(MapSet.new(tiles), MapSet.new(word))
  end
  def suggest(tiles, dict) do
    Enum.filter(dict, fn(word) -> matches?(tiles, word) end)
  end
end

ExUnit.start
defmodule CheatTest do
  use ExUnit.Case
  test "match" do
    refute Cheat.matches?('a', 'abc')
    assert Cheat.matches?('abc', 'a')
  end
  test "suggest" do
    assert Cheat.suggest('abc', ['a', 'ba', 'fa', 'la']) == ['a', 'ba']
  end
end
