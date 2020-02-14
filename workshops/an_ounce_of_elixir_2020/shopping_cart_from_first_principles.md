# Building a shopping cart from first principals

Slide: Goals

We're a team of developers and we've been tasked with making a shopping cart library. 
We want the library to be able to answer these questions:

1. The web UI team wants to know:
    a. How many items are in the cart?
    b. What are the items in the cart? How many of each item?
    c. What's the total for the cart?
2. The checkout team wants to know:
    a. How much do we charge the customer for the items in the cart?
3. The marketing team wants to know:
    a. What was the first item they put in the cart? (That's probably what they came for.)
    b. What items did they take out of the cart? (These are things they wanted to buy but decided not to.)
    c. What was the last item they took out of the cart? (That's probably the thing they really wanted but couldn't afford.)

We're going to use Elixir to make this library. I know that most of us have little or no experience with
Elixir, so we'll start with the basics and learn a bunch of first concepts together. Then after lunch,
we can break into groups and write our shopping cart library.

## iex

For each person with a computer, verify they are able to launch iex.

`iex` is a tool that comes with Elixir. It stands for "interactive Elixir", but we sometimes use a more generic term
called a "REPL" or "read-evaluate-print-loop". That means that we can type one line of code, hit enter, and see
the result immediately. 

We're going to use the REPL, `iex`, all morning. It's one of my favorite tools for learning a new language,
because I can try new things out and see what it does immediately.

## Expressions

One of the first things to know about Elixir is that everything is an expression. Expressions are math. Expressions always have a return value.

```
0 # returns 0
0 + 0 # returns 0
0 + 1 # returns 1
1 + 1 # ...
1 - 1
1 - 0
0 - 0
1 * 2
1 * 1
1 * 0
1 / 1 # Floating point, not integer
0 + 0.0 # also floating point
1 / 2
2 / 3
```

## Bound variables and Pattern Matching

Imperative - Do the thing.
Declarative - The thing is true. The thing is a relationship.

Describe imperative and declarative language using examples from talking with children.

```
a = 0 # Balancing left from right
b = 1
0 = 1 # Not balanced
_ = 1 # Matches anything
_not_needed = 1
```

## Lists

```
[x, y, z] = [0, 1, 2] # Balancing from a list
[x, y, z] = [0, 1] # Not balanced
[1, y, z] = [0, 1, 2] # Not balanced
[0, y, z] = [0, 1, 2] # Balanced
[_, 1, 2] = [0, 1, 2] # Balanced
a = [0, 1, 2]
a # [0, 1, 2]
[x, y, z] = a # Still balanced
[1, y, z] = a # not balanced
[0, y, z] = a # Balanced
```

Heads and tails

```
[head | tail] = [0, 1] # Decomposing a list into the head and tail
head # 0
tail # [1] why?
[a | [b | c]] = [0, 1] # Same, but with multiple heads
a # 0
b # 1
c # [] why?
[head | tail] = [] # Doesn't work, because there is no head
```

## Atoms

```
0 # returns 0
:atom # returns :atom
:apple # returns :apple
```

An atom is a similar to a variable. It has a constant value that's the same as it's name.
We often use it when we want to refer to a thing we already know or would recognize.

```
:apple # returns :apple
:orange # returns :orange
:ok # returns :ok
:error # returns :error
```

Sometimes we use atoms to convey messages and verify that we got what we expected.

```
:ok = IO.puts("I'm writing to the screen")
:not_ok = IO.puts("I'm writing to the screen but this will also throw a MatchError")
```

Note that `IO.puts` created a "side effect". It wrote something to the screen. Besides creating a side effect,
it still returned a value of `:ok` which did not match the `:not_ok` atom we tried to match to it.

```
:apple = :apple # An :apple is an :apple, so they match
:apple = :orange # Bzzt
:apple == :orange # Gentle bzzt - note the double equals sign is asking whether they are equal
:apple == :apple
item = :apple # returns :apple because it's an expression
items = [:apple, :orange, :banana] # here's a list of atoms
[item | rest] = items # :apple, [:orange, :banana]
```

## Tuples

A tuple is a list of elements. It doesn't tell us what things mean, but it does tell us things are probably related.
We can use tuples to put things together that maybe belong together in how we're thinking about our program.

```
center = {0, 0} # What's this mean? Maybe it's the coordinates for a point at the origin of a graph?
{x, y} = {0, 0} # Maybe this is more clear?
x # 0
y # 0
interval1 = {1, :year} # More obvious what this means
interval2 = {12, :months}
interval1 == interval2 # false. Elixir doesn't know what our atoms mean. The meaning of an atom is for the programmer, not the program.
length = {15, :kilometers}
cost = {12, :zł} # We might use atoms to identify what our "units of measure" are
{:apple, {0.65, :zł}} # Tuples can be nested inside tuples
{event_type, item} = {:item_added, {:apple, {0.65, :zł}}} # We can reach inside to do pattern matching
{event_type, {product, cost} = item} = {:item_added, {:apple, {0.65, :zł}}} # We can reach inside the inside parts too
```

## Lists of tuples

```
cart_events = [
    {:item_added, {:apple, 6, 0.75}},
    {:item_added, {:pineapple, 1, 8.0}},
    {:item_added, {:orange, 2, 1.5}},
    {:item_added, {:banana, 2, 1.0}},
    {:item_removed, {:pineapple, 1}},
    {:item_removed, {:orange, 1}}
]
```

Here we put together a lot of the information from everything we've done so far, into
a list that actually seems to contain a lot of information. We can see the behavior of a
shopper, how they interacted with our store's products and their shopping cart.

Each item in our list represents something the shopper did. They added six apples to their cart,
and each one costs 75 groszy. My pronunciation is horrible. Then they added a pineapple for 8 złoty,
two oranges for 1-1/2 złoty each, and two bananas for 1 złoty each.

But then things started to look expensive. A pineapple is maybe a luxury? They took the pineapple out,
and then they removed one of the oranges too.

With a list like this, we can start to answer some of those questions, like "How many items are in the cart?"

## Functions

Functions are expressions and return a value, just like everything we've done so far. Elixir provides some
functions in it's kernel, and other functions in libraries. But the kernel is actually a library too, it's just
the library that's easiest to use. 

Let's try some functions from the kernel.

```
div(10, 3) # Integer division
round(3.75) # 4
floor(3.75) # 3
min(1, 2) # 1
max(1, 2) # 2
```

When we start using standard libraries, we have many more functions. We're going to use a standard library
called Enum, short for "enumerable", a lot today. Here are some examples of functions we get from Enum.

```
my_list = [6, 3, 9, 15, 12]
Enum.min(my_list) # 3
Enum.max(my_list) # 15
Enum.count(my_list) # 5
Enum.sum(my_list) # 45
Enum.sort(my_list) # [3, 6, 9, 12, 15]
```

Here are some guidelines for functions. Not all of these are always true, but when we make our own functions
we're going to follow these rules.

Slide: Functions

* Functions are referentially transparent.

A function will return the same value whenever it's given the same arguments. Another way of saying this is that nothing about the state of a program can affect how a function works. Another way of saying this is that a function call and its result are always interchangeable, without impacting the meaning of a program.

* Functions are composable.

We can apply one function to the result of another function. We can string a bunch of functions together to make a program. In functional programming, that's typically how we make a program.

```
Enum.sum(Enum.dedup([0, 1, 1, 2, 3, 4, 5, 5])) # 15
Enum.dedup([0, 1, 1, 2, 3, 4, 5, 5]) |> Enum.sum() # 15, and a little easier to read
[0, 1, 1, 2, 3, 4, 5, 5] |> Enum.dedup() |> Enum.sum() # 15, and easiest to read
```

* Functions can be arguments to other functions.

This is where things get really powerful, and we're going to use this a lot today.

```
qty_and_cost = [
    {6, 0.75},
    {1, 8.0},
    {2, 1.5},
    {2, 1.0}
]

costs = Enum.map(qty_and_cost, fn {qty, cost} -> qty * cost end) # Apply a function to each element
total = Enum.sum(costs) # Calculate the sum
```

This can also be done in one function, called a reduction:

```
Enum.reduce(qty_and_cost, 0, fn {qty, cost}, accumulator -> accumulator + qty * cost end)
```

## Lunch

The Enum module is part of Elixir's standard library, and I'm pretty sure that function might have blown a
few minds. Next we'll write our own module.

But first, let's have lunch.

## Mob programming

Slide: Mob programming defintion

Mob programming is like pairing when we are more than a pair. It's one computer, one keyboard, and a few people. One person "drives" the keyboard while one or more people "navigate". Then we switch roles and keep going.

Slide: Mob programming guidelines

* “Yes and” goes further than “no” and “but”.
* Kindness, consideration, and respect are way better than having anyone in charge.
* Declarative language and experience sharing goes further than imperative language.
* Thinking out loud helps everyone in the mob follow what you’re doing.
* We speak at the highest level of abstraction the mob is able to digest in the moment.
* Drivers type code that the mob proposes.
* We learn differently when we’re the driver, so it’s important that everyone drives.
* Rotations can happen as often as every five minutes.
* Learning is contributing.

How many mobs? What are the spoken languages? Who is willing to share their computer
and let other people type on it?

Start as one big mob with drivers on each computer, split into smaller mobs if possible.

## `mix`

Elixir gives us another tool called `mix` that does a lot of things, but the two we'll use today
are setting up a new project and testing the code that we write.

Let's start a new project with `mix`.

```
mix new cart
cd cart/
mix test
```

Look at that, we haven't written any code and we already have a passing test!

Let's look at what `mix new` did for us.

`mix.exs` - This file defines our project. For a library project, we don't need to change anything in here.
It's good to go.

`lib/cart.ex` - This file defines our Cart module. We'll create functions in here that do the things our partners
need from us.

`test/cart_test.exs` - This file tests our Cart module. We'll write tests that prove our code does what we
expect it to do.

There are two ways to write tests. We can write them here in this file, usually using an `assert` statement to
tell Elixir we want to prove that something happens. Here, we're asking it to prove that `Cart.hello()` returns
the atom `:world`. We're going to write our tests this way today.

There's another way called `doctest`. It looks in our documentation for examples, and then runs the examples.
If it gets the same result the documentation says it should get, then the test passes. I'm actually going to
remove the doctests so we can focus on just one way of testing today.

## Modules

So now we have our first Elixir project, and we can see that it starts with `defmodule`. This is how we write a
module, which is really just a home for our functions.

`mix new` gave us one function to start with, called `hello`. What's that do now?

Our project doesn't need a function called `hello` that returns an atom `:world`, so the next thing we'll do it
remove this function. Since we're removing this function, we can also remove the test that `mix new` made for this
function.

So how do we start?

## Acceptance Criteria

Slide: Goals

1. The web UI team wants to know:
    a. How many items are in the cart?
    b. What are the items in the cart? How many of each item?
    c. What's the total for the cart?
2. The checkout team wants to know:
    a. How much do we charge the customer for the items in the cart?
3. The marketing team wants to know:
    a. What was the first item they put in the cart?
    b. What items did they take out of the cart?
    c. What was the last item they took out of the cart?

We started with a list of goals that give us a pretty good understanding of the problem. But it's not very specific.

By the time the project gets to us, the programmers, we're probably working from a "ticket" that describes what needs
to be done. Hopefully the ticket spells this out pretty specifically, with a description of how we know we did it right.

We call that the "acceptance criteria". Here's what that looks like. 

Slide: Acceptance criteria

Given a list of cart events, ordered by time with the most recent event at the head of the list, with each event represented as a tuple in these forms:

* `{:item_added, {product, qty, price}}` where `product` is an atom, `qty` is an integer, and price is a floating point number
* `{:item_removed, {product, qty, price}}` where `product` is an atom, `qty` is an integer, and `price` is a floating point number.

Provide the following functions:

* `show_cart(events)` returning a list of current cart items. Each item in the list should be represented as a list of tuples in the form `{product, {qty, price}}`. An empty cart should return an empty list.
* `get_total(events)` returning a floating point number representing the total value of all products in the final cart. The total for an empty cart should be 0.00.
* `count_items(events)` returning a count of current cart items. An empty cart should return 0.
* `get_added_items(events)` returning a list of all `product`s added to a cart, regardless of whether they were later removed, in chronological order with the most recently added item at the head of the list. If no items were added, the returned list should be empty.
* Always use the latest price.

## Tests

Let's work on the first Acceptance Criteria together, and then all of you can work together on the rest.
The first acceptance criteria is the hardest, I think.

We can start with a test, and then write code to pass that test. 

`test/cart_test.exs`

```
# show_cart(events) returns a list of current cart items.
# Each item in the list should be represented as a list of tuples in the form `{product, {qty, price}}`.
# An empty cart should return an empty list.

test "show_cart returns an empty list when it receives no events" do
  events = []
  assert Cart.show_cart(events) == []
end
```

`mix test`

`lib/cart.ex`

```
def show_cart([]) do
  []
end
```

`mix test`

That was easy. The next test is definitely harder.

```
test "show_cart returns an empty list if an item in any quantity is added and then the same qty is removed" do
  random_qty = Enum.random(1..100)

  events = [
    {:item_removed, {:dinosaur_egg, random_qty, 125.00}},
    {:item_added, {:dinosaur_egg, random_qty, 125.00}}
  ]

  assert Cart.show_cart(events) == []
end
```

```
  def show_cart(events) do
    Enum.reverse(events)
    |> Enum.reduce(
      [],
      fn {event, {product, qty, price}}, cart ->
        [{_product, {current_qty, _price}} = _item | rest] = move_to_head(cart, product)
        adjusted_qty = calculate_adjustment(event, qty) + current_qty

        [{product, {adjusted_qty, price}} | rest] |> remove_items_with_no_qty()
      end
    )
  end

  defp move_to_head(cart, product) do
    item = Enum.find(cart, {product, {0, 0.00}}, fn {item, _} -> item == product end)
    rest = Enum.filter(cart, fn {item, _} -> item != product end)
    [item | rest]
  end

  defp calculate_adjustment(:item_added, qty) do
    qty
  end

  defp calculate_adjustment(:item_removed, qty) do
    -1 * qty
  end

  defp remove_items_with_no_qty(cart) do
    Enum.filter(cart, fn {_product, {qty, _price}} -> qty != 0 end)
  end
```

`mix test`. Phew.

Next test.

```
  test "show_cart returns a list of current cart items in the form {product, {qty, price}}" do
    events = [
      {:item_added, {:iguana_leash, 3, 12.00}},
      {:item_added, {:zombie_repellent, 12, 3.00}}
    ]

    items = [
      {:iguana_leash, {3, 12.00}},
      {:zombie_repellent, {12, 3.00}}
    ]

    cart = Cart.show_cart(events)
    Enum.each(items, fn item -> assert item in cart end)
  end
```

Let's see this fail.

`mix test`

What? Why did it pass?

## Mobbing

Slide: Acceptance criteria

Three more functions to write and test. Let's have you give it a try. I'll be here to answer questions and
help out if you need.