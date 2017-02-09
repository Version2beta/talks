defmodule PickTest do
  use ExUnit.Case
  doctest Pick

  test "Picking none returns none" do
    assert Pick.pick('', '') == ''
  end
  test "Picking for an empty word returns none" do
    assert Pick.pick('abc', '') == ''
  end
  test "Picking for a word without any tiles returns none" do
    assert Pick.pick('', 'abc') == ''
  end
  test "Picking a word when we don't have any tiles" do
    assert Pick.pick('abc', 'd') == ''
  end
  test "Picking a tile for a one letter word" do
    assert Pick.pick('abc', 'a') == 'a'
  end
  test "We can pick out all the tiles for a word" do
    assert Pick.pick('abcdef', 'bdf') == 'bdf'
  end
  test "We can't pick out all of the tiles for a word we can't spell" do
    assert Pick.pick('abc', 'cdef') == 'c'
  end
  test "We can't pick out any tiles for a word we can't spell at all" do
    assert Pick.pick('abc', 'def') == ''
  end
  test "Once a tile has been picked, it can't be used again" do
    refute Pick.pick('jumble', 'bumblebee') == 'bumblebee'
  end
end
