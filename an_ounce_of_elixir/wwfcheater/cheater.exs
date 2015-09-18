defmodule Cheater do

  def pick([], _), do: []
  def pick([head | tail], elt) when head == elt, do: tail
  def pick([head | tail], [elt]) when head == elt, do: tail
  def pick([head | tail], elt), do: [head] ++ pick(tail, elt)

end


ExUnit.start

defmodule CheaterTest do
  use ExUnit.Case

  test "pick" do
    assert MyList.pick([], nil) == []
    assert MyList.pick([1], 1) == []
    assert MyList.pick([1], 2) == [1]
    assert MyList.pick([0, 1, 2], 1) == [0, 2]
    assert MyList.pick([0, 1, 1, 2], 1) == [0, 1, 2]
    assert MyList.pick('abcde', 'c') == 'abde'
  end

end
