defmodule Cheater do
  def string_delete(word, element) do
    Enum.join enum_delete(String.split(word, "", trim: true), element, [])
  end
  def enum_delete([head | tail], element, acc) when head == element do
    acc ++ tail
  end
  def enum_delete([head | tail], element, acc) when head != element do
    enum_delete(tail, element, acc ++ [head])
  end
  def enum_delete([], _, acc) do
    acc
  end
end

# tests

ExUnit.start

defmodule CheaterTest do
  use ExUnit.Case

  test "string_delete removes an element from an array" do
    assert Cheater.string_delete("abc", "b") == "ac"
    assert Cheater.string_delete("abc", "d") == "abc"
  end

end
