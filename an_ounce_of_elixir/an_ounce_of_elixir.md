# An Ounce of Elixir

## First, just a drop of Erlang...

There's a programming language called Erlang, and it's really good at a few important things:

* It's good at large problems. It's not unusual for an Erlang program to have hundreds of thousands or even millions of users. Your cell phone calls are moved around using Erlang. WhatsApp has a billion customers sending text messages using Erlang.
* It's very stable. When you absolutely need to keep a program running, you might choose Erlang. One telephone switch running Erlang once had an average of less that 32 miliseconds of down time a year.
* It's designed to be fault-tolerant, not just stable. That's part of the reason it's so reliable. Parts of the system can crash, and that's totally okay.

Unfortunately, it also has some characteristics that make it a less popular language:

* It looks funny to people who program in object oriented programming languages.
* It can be hard for new people to get involved. The community of people who use it are academics and conservative computer scientists working on infrastructure projects.

Erlang is great. I love Erlang, and I've spent quite a bit of time learning it. I really like the community of people who develop in Erlang too, even if I'm pretty intimidated by them. I'd love for us to learn Erlang too, but even if we did it might be very hard to even find a job doing Erlang, at least as a junior developer. That makes me sad.

## Along comes José Valim

In January of 2012, a young programmer from Brazil who was already a member of the Ruby on Rails Core Team saw a way we could do something different with Erlang. He took the innards of the language and put a new and slightly different language on top of it. That language is Elixir.

I want to take a minute and say a few things about José. I've met him and talked with him a few times, and he's an exceptional human being. He's brilliant, and he's good at making complex things simple and hard things easy. He's an incredible programmer, but he's humble and happy to help people learn new things with him. He's approachable and warm, organized and smart, and good at community. I have a lot of respect for him.

So does the Erlang community. This year, they named him Erlang User of the Year.

Elixir inherits all of the good things from Erlang, and it adds some new good things.

* A more modern, Ruby-like syntax.
* A better set of tools for learning the language.
* A younger, less conservative community of users.

About a year ago, Elixir hit it's first official production release, version 1.0. It's pretty easy to learn. Companies are using it for their products. Startups are using it to prove their ideas. It plays nicely at internet scale.

It seems to be the tool I was looking for.

## Learning Elixir

When I'm learning a new programming language, I like to use two tools.

* A REPL. REPL stands for Read - Eval - Print loop, but really what it means is that you can type program stuff in and get answers right away. This is particularly useful when I'm learning a new language because I get to experiment with how the syntax works. I can type things in the wrong way over and over, and get error after error, until I get it right.
* A test library. Test libraries run tests, and when I'm learning a new language I like to write a lot of tests. I may think I know how things work, but I really prefer to prove it. If I write without tests and it fails, I may have no idea why. When it fails on a test, I have a better idea why. Sometimes I get surprising results and learn a lot more than I expected.

Those are the two tools we're going to use tonight - a REPL and a test library. And Elixir.

## Getting started

### Installing Elixir

(http://elixir-lang.org/install.html)[http://elixir-lang.org/install.html]

### Running an Elixir REPL

Start the shell: `iex`

Try some Elixir:

```
iex(1)> IO.puts "Hello world!"
Hello world!
:ok
iex(2)> ^g
User switch command
 --> q
```

### A Words With Friends cheater program

Let's start figuring out a real program.

Anyone here play Words with Friends? I'm pretty good at it, and I usually win. To make things more interesting, a few years ago I offered to my daughter that she could cheat in her games with me, as long as she used a program she wrote herself. So she wrote a program in Ruby that helped her find words she could play with the tiles she has.

Let's try writing that in Elixir. We'll use the same basic algorithm that she and I worked out because it's pretty easy to follow, and our objective is to learn the language more than to figure out cool algorithms.

Her algorithm works like this. You take a word from the dictionary, and a bunch of letters from your rack. Starting at the left, you take a letter from the word and try to pull that letter from your rack. After you've pulled all the letters you've got, you check to see if you made the word.

We can try that in the REPL first.

First, lets try to figure out how to test one word. For that, we need a word. How do we represent that in Elixir?

```
iex> 'jumble'
'jumble'

iex> 'jumble' == "jumble"
false

iex> 'jumble' == to_char_list "jumble"
true

iex> "jumble" |> to_char_list
'jumble'

iex> "jumble" |> to_char_list |> Enum.sort
'bejlmu'

iex> 'jumble' |> Enum.sort
'bejlmu'

iex> 'jumble' |> Enum.shuffle
'muebjl'

iex> for c <- 'jumble', do: c
'jumble'

iex> for c <- 'jumble', do: IO.puts c
106
117
109
98
108
101
[:ok, :ok, :ok, :ok, :ok, :ok]

iex> for c <- [106, 117, 109, 98, 108, 101], do: c
'jumble'

iex> for ages <- [106, 117, 109, 98, 108, 101], do: ages
'jumble'

iex> for c <- 'jumble', do: Enum.member?('muebjl', c)
[true, true, true, true, true, true]

iex> for c <- 'jumble', do: Enum.member?('mumble', c)
[false, true, true, true, true, true]

iex> word = to_char_list "jumble"
'jumble'

iex> word
'jumble'

iex> tiles = to_char_list "muebjl"
'muebjl'

iex> for c <- word, do: Enum.member?(tiles, c)
[true, true, true, true, true, true]

iex> Enum.all? for c <- word, do: Enum.member?(tiles, c)
true

iex> Enum.all? for c <- 'jumble', do: Enum.member?('mumble', c)
false

iex> {:ok, dict} = File.read("words.txt")
"aa\naah\naahed\naahing\naahs\naal\naalii\naaliis\naals..."

iex> dict
"aa\naah\naahed\naahing\naahs\naal\naalii\naaliis\naals..."

iex> words = dict |> String.split "\n"
["aa", "aah", "aahed", "aahing", "aahs", "aal", "aalii", "aaliis", "aals", ...

iex> words |> Enum.count
173140

iex> words = dict |> String.split("\n") |> Enum.map fn word -> to_char_list word end
['aa', 'aah', 'aahed', 'aahing', 'aahs', 'aal', 'aalii', 'aaliis', 'aals', ...

iex> words |> Enum.count
173140

iex> tiles
'muebjl'

iex> Enum.filter words, fn word -> Enum.all? for c <- word, do: Enum.member?(tiles, c) end
['be', 'bee', 'beebee', 'bejumble', 'bel', 'bell', 'belle', 'bleb', 'blellum', ...
```

We have a problem. How did 'bejumble' get through? We only have one 'b' and one 'e' in our tiles.

Let's switch to a test driven approach. Maybe we won't make mistakes like this one.

```cheater.exs
ExUnit.start

defmodule CheaterTest do
  use ExUnit.Case

  test "learning some Elixir" do
    assert "jumble" == "jumble"
    refute 'jumble' == "jumble"
    assert 'jumble' == "jumble" |> to_char_list
    assert 'jumble' |> Enum.sort == 'bejlmu'
  end
end
```

```
...
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
...
defmodule Cheater do
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
end
```

```
...
  test "match" do
    assert Cheater.match('', '') == true
    assert Cheater.match('abc', 'abc') == true
    assert Cheater.match('abc', '') == true
    assert Cheater.match('', 'abc') == false
    assert Cheater.match('abc', 'def') == false
    assert Cheater.match('ujmleb', 'jumble') == true
  end
...
  def match(tiles, word) do
    word == pick(tiles, word)
  end
```

```
...
  test "dict" do
    [word | words] = Cheater.make_dict "words.txt"
    assert is_list words
    assert is_list word
  end
...
  def make_dict(file) do
    {:ok, dict} = File.read(file)
    dict |> String.split("\n") |>
      Enum.map fn word ->
        to_char_list word
      end
  end
```

```
...
  test "find" do
    words = Cheater.make_dict("words.txt")
    matches = Cheater.find('ujmebl', words)
    assert Enum.member? matches, 'jumble'
    refute Enum.member? matches, 'mumble'
    refute Enum.member? matches, 'bell'
  end
...
  def find(tiles, words) do
    Enum.filter words, fn word -> match tiles, word end
  end
```
