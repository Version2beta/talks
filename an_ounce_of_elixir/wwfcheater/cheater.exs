defmodule Cheater do
  @moduledoc """
  Find words that can be made from a jumbled collection
  of letters.
    ```
    iex> words = Cheater.make_dict "words.txt"
    iex> Cheater.find('uljemb', words)
    ['be', 'bel', 'blue', 'blume', ...]
    ```
  """

  @doc """
  Find the intersection between a dictionary word and a
  set of tiles.
    `pick('mujleb', 'jumble') == 'jumble'`
  """
  def pick(tiles, word), do: pick(tiles, word, '')
  def pick(tiles, word, int) when tiles == '' or word == '' do
    int
  end
  def pick(tiles, [char | chars], int) do
    cond do
      Enum.member? tiles, char ->
        pick(tiles -- [char], chars, int ++ [char])
      true ->
        pick(tiles, chars, int)
    end
  end

  @doc """
  Test whether a word can be made from a set of tiles.
    `match('mujleb', 'jumble') == true`
  """
  def match(tiles, word) do
    word == pick(tiles, word)
  end

  @doc """
  Returns a list of char_lists from a file containing words,
  one word per line.
    `words = make_dict("words.txt")`
  """
  def make_dict(file) do
    {:ok, dict} = File.read(file)
    dict |> String.split("\n") |>
      Enum.map fn word ->
        to_char_list word
      end
  end

  def find(tiles, words) do
    Enum.filter words, fn word -> match tiles, word end
  end
end


ExUnit.start

defmodule CheaterTest do
  use ExUnit.Case

  test "learning some Elixir" do
    assert "jumble" == "jumble"
    refute 'jumble' == "jumble"
    assert 'jumble' == "jumble" |> to_char_list
    assert 'jumble' |> Enum.sort == 'bejlmu'
  end

  test "pick" do
    assert Cheater.pick('', '') == ''
    assert Cheater.pick('abc', '') == ''
    assert Cheater.pick('abc', 'd') == ''
    assert Cheater.pick('abc', 'b') == 'b'
    assert Cheater.pick('abcdef', 'bdf') == 'bdf'
    assert Cheater.pick('abcabc', 'abc') == 'abc'
    assert Cheater.pick('abc', 'abcabc') == 'abc'
    assert Cheater.pick('ujmleb', 'jumble') == 'jumble'
  end

  test "match" do
    assert Cheater.match('', '') == true
    assert Cheater.match('abc', 'abc') == true
    assert Cheater.match('abc', '') == true
    assert Cheater.match('', 'abc') == false
    assert Cheater.match('abc', 'def') == false
    assert Cheater.match('ujmleb', 'jumble') == true
  end

  test "dict" do
    [word | words] = Cheater.make_dict "words.txt"
    assert is_list words
    assert is_list word
  end

  test "find" do
    words = Cheater.make_dict("words.txt")
    matches = Cheater.find('ujmebl', words)
    assert Enum.member? matches, 'jumble'
    refute Enum.member? matches, 'mumble'
    refute Enum.member? matches, 'bell'
  end

end
