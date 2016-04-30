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

## When to use Elixir and Phoenix instead of Rails or Express

0. When speed counts. Phoenix typically responds an order of magnitude faster, and more consistently too. Plus it uses all the cores better.
0. When you need to do things asynchronously. Concurrency is pretty much the core competency of Erlang and Elixir. The patterns and abstractions are cleaner and smaller than Ruby libraries or Node.js.
0. When you need to scale horizontally. Object oriented programming breaks down quickly when it's modeled across a cluster. Elixir's share-nothing, message-passing, functional programming maps well to a distributed approach.
0. When you need to push real-time data. Phoenix channels offer soft real-time performance that scales well. They've been demonstrated with as many as 2 million connections per server.
0. When your application will be large. Elixir provides excellent tooling for creating and deploying umbrella applications, and the underlying Erlang supervision tree pattern enforces loosely coupled services.
0. When you want to attract the best developers. The market is flooded with RoR and Node.js developers. Finding seniors who know a functional programming stack is a strong indicator of dedication to be a better programmer.

## Getting started

### Installing Elixir and Phoenix

#### Elixir

(http://elixir-lang.org/install.html)[http://elixir-lang.org/install.html]

#### Phoenix

```
mix local.hex
mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez
```

#### Node.js > v5.0

```
node --version
```

(https://nodejs.org/dist/latest-v5.x/)[https://nodejs.org/dist/latest-v5.x/]

#### PostgreSQL

```
brew rm postgresql --force
brew install postgresql
brew services start postgresql
createdb `whoami`
```

## Learning Elixir

When I'm learning a new programming language, I like to use two tools.

* A REPL. REPL stands for Read - Eval - Print loop, but really what it means is that you can type program stuff in and get answers right away. This is particularly useful when I'm learning a new language because I get to experiment with how the syntax works. I can type things in the wrong way over and over, and get error after error, until I get it right.
* A test library. Test libraries run tests, and when I'm learning a new language I like to write a lot of tests. I may think I know how things work, but I really prefer to prove it. If I write without tests and it fails, I may have no idea why. When it fails on a test, I have a better idea why. Sometimes I get surprising results and learn a lot more than I expected.

Those are the two tools we're going to use tonight - a REPL and a test library. And Elixir.

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
rd = ['
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

#### Create a Phoenix project

```
mix phoenix.new hello
cd hello
vi config/dev.exs
mix ecto.create
mix phoenix.server
```

Alternatively, `iex -S mix phoenix.server`. Hit the test site at (http://localhost:4000)[http://localhost:4000]

## Debug through iex

Edit `web/controllers/page_controller.ex`:

```
1 defmodule Hello.PageController do
2   use Hello.Web, :controller
3   require IEx
4
5   def index(conn, _params) do
6     IEx.pry
7     render conn, "index.html"
8   end
9 end
```

Run with `iex -S mix phoenix.server`. Navigate to `http://localhost:4000/`.

Inside a template, like `web/templates/page/index.html.eex`:

```
<div class="jumbotron">
  <h2><%= gettext "Welcome to %{name}", name: "Phoenix!" %></h2>
  <p class="lead">A productive web framework that<br />does not compromise speed and maintainability.</p>
  <% require IEx %>
  <% message = "hello" %>
  <% IEx.pry %>
</div>
...
```

Inside a model:

First, generate a model.

```
mix phoenix.gen.model User users username:string
mix ecto.migrate
```

Edit the model, `web/models/user.ex`:

```
defmodule Hello.User do
  use Hello.Web, :model
  require IEx

  schema "users" do
    field :username, :string

    timestamps
  end

  @required_fields ~w(username)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    IEx.pry
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
```

Edit the controller to call the changeset function:

```
defmodule Hello.PageController do
  use Hello.Web, :controller
  alias Hello.User

  def index(conn, _params) do
    user = User.changeset(%User{}, %{username: "test"})
    render conn, "index.html"
  end
end
```

And run `iex -S mix phoenix.server`:

```
Interactive Elixir (1.2.1) - press Ctrl+C to exit (type h() ENTER for help)
pry(1)> model
%Hello.User{__meta__: #Ecto.Schema.Metadata<:built>, id: nil, inserted_at: nil,
 updated_at: nil, username: nil}
pry(2)> params
%{username: "test"}
```

In another shell:

```
$ siege -c 1000 -t 10s http://localhost:4000/api/abc
```

## A better project organization

Use a mix umbrella application to keep web and business logic separate.

```
mix new cheater --umbrella
cd cheater/apps/
mix new solver
mix phoenix.new web --no-html --no-ecto --no-brunch --module Cheater.Web
cd ..
ls -al apps/solver/
ls -al apps/web/
ls -al deps/
mix test --trace
```

cheater/apps/solver/mix.exs
cheater/apps/solver/lib/solver.ex
cheater/apps/solver/test/solver_test.exs

```
iex(1)> Cheater.Solver.suggest 'abc', ['a', 'ba', 'fa', 'la']
['a', 'ba']
```

cheater/apps/web/test/integration/cheater_test.exs
cheater/apps/web/web/router.ex
cheater/apps/web/web/controllers/api_controller.ex
cheater/apps/web/web/views/api_view.ex

```
$ iex -S mix phoenix.server
iex(1)> :observer.start
```
