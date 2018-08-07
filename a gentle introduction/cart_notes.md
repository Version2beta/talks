## Live coding in the REPL

### Pattern matching

```
> x = 1
1
```

* Imperative languages purport to control the world. “Set x to 1. Go stick the number 1 in the memory location called `x`.”
* Declarative languages describe relationships. “x and 1 have the same value. `x` is the name I'm using for the value 1.” 

* Good for our brains?
* Imperative and declarative communication in child development.
* Robin Dunbar, Dunbar’s Number, and the relationship between network size and the orbito-medial prefrontal cortex.

* Variables in Elixir are more like names matched to values
* `=` is the match operator, not assignment

* How it works in Erlang - `MatchError` - but Elixir is more forgiving

```
> x = 2
2
```

* The pin operator

```
> ^x = 2
2
> ^x = 3
** (MatchError) no match of right hand side value: 3
```

* Destructuring assignment is just pattern matching in Elixir, binding a name to a value

```
> {0, y} = {0, 1}
{0, 1}
>y
1
> {1, y} = {0, 1}
** (MatchError) no match of right hand side value: {0, 1}
> {0, ^y} = {0, 1}
{0, 1}
> {0, ^y} = {0, 2}
** (MatchError) no match of right hand side value: {0, 2}
```

* Cool uses for this in defining functions and dealing with values we soon

### Pure functions

```
> defmodule Pure do
> def square(x), do: x*x
> end
```

* Returns the same value given the same arguments.
* Any given function call can be replaced with its result without changing the meaning of the program.
* Nothing about the state of a program (or the database or the world) outside of a function can impact the result of a function.
* Nothing inside the function can affect what’s outside the function (no side effects)

### Immutable state

We use state to model things in the real world.

* In object oriented languages, properties distinguish one object from another.
* In functional programming, we use purely functional data structures.

There's an important distinction between these two ways of managing identity.

In OO programming: 

* Identity is the current state of an object; the current properties of an object are the identity of that object.
* The object oriented abstraction gives us only one identity, the current snapshot of an object's state. We could maintain a journal, but we don't get that for free with object oriented programming.
* State is mutated in response to outside code calling methods on our object.

```
> defmodule Point do
```

I'm defining a new module.

```
> defstruct x: 0, y: 0
```

That module defines a Point data structure that can be used by other modules to interact with this module.

```
> def moved_randomly(point) do
> %Point{x: point.x + Enum.random(-5..5), y: point.y + Enum.random(-5..5)}
> end
```

It also defines a function that transforms Point data.

```
> end
```



```
> p0 = %Point{}
%Point{x: 0, y: 0}
```

* As a user of the Point module, we're responsible for maintaining our state.
* State is immutable.

```
> Point.moved_randomly(p0)
%Point{x: -5, y: 5}
> p0
%Point{x: 0, y: 0}
```

* We transform state from one version to the next using pure functions.

```
> p1 = Point.moved_randomly(p0)
%Point{x: 2, y: -4}
> p0
%Point{x: 0, y: 0}
> p1
%Point{x: 2, y: -4}
```

* We can always access at least two versions of our state - before and after transformation.
* By extension, we actually have *every* version of state, because we choose what to discard.

```
> Enum.reduce(0..10, [p0], fn(i, [current | _previous] = acc) -> [Point.moved_randomly(current)] ++ acc end)
[
  %Point{x: 3, y: -9},
  %Point{x: -2, y: -7},
  %Point{x: 1, y: -2},
  %Point{x: 3, y: 3},
  %Point{x: 6, y: 5},
  %Point{x: 6, y: 4},
  %Point{x: 2, y: 0},
  %Point{x: 6, y: -4},
  %Point{x: 2, y: -5},
  %Point{x: 1, y: -4},
  %Point{x: -2, y: -5},
  %Point{x: 0, y: 0}
]
```

* Identity can easily be an immutable, append-only collection of states over time.
* Extremely rich source of data for answering questions, even those we don’t yet know to ask.

## Live coding an event-based shopping cart

`mix new cart` and edit files for a decent starting point

### `test/cart_test.exs`

Create some events:

```
  @some_events [
    {:item_added, %Cart.Item{sku: :nail_polish_elephant, qty: 1, cost: 9.99}},
    {:item_added, %Cart.Item{sku: :pumice_stone, qty: 10, cost: 2.79}},
    {:item_added, %Cart.Item{sku: :nail_file_xl, qty: 1, cost: 14.69}},
    {:item_added, %Cart.Item{sku: :nail_polish_elephant, qty: 3, cost: 9.99}},
    {:item_removed, %Cart.Item{sku: :pumice_stone, qty: 10, cost: 2.79}},
    {:item_added, %Cart.Item{sku: :pumice_stone_xl, qty: 1, cost: 7.79}},
  ]
```

Create an expected result:

```
  @expected_result %Cart{items: [
    %Cart.Item{sku: :nail_polish_elephant, qty: 4, cost: 9.99},
    %Cart.Item{sku: :nail_file_xl, qty: 1, cost: 14.69},
    %Cart.Item{sku: :pumice_stone_xl, qty: 1, cost: 7.79},
  ], total: 62.44}
```

Create a test:

```
  test "Processing some events gives us our expected cart" do
    result = Cart.process(%Cart{}, @some_events)
    assert result.total == @expected_result.total
    assert Enum.count(result.items) == 3
    assert @expected_result.items -- result.items == result.items -- @expected_result.items
  end
```

### `cart.ex`

Create a couple of structures:

```
  defstruct items: [], total: 0

  defmodule Item do
    defstruct sku: nil, qty: 0, cost: 0
  end
```

Implement `Cart.process` for a list of events:

```
  def process(cart, events) when is_list(events) do
    Enum.reduce(events, cart, fn(event, cart) -> process(cart, event) end)
  end
```

Implement `Cart.process` for an `:item_added` event:

```
  def process(%Cart{items: items} = _cart, {:item_added, item} = _event) do
    new_items = dedup_items(items, item)
    %Cart{items: new_items, total: calculate_total(new_items)}
  end
```

Implement `Cart.process` for an `:item_removed` event:

```
  def process(%Cart{items: items} = _cart, {:item_removed, item} = _event) do
    new_items = dedup_items(items, %Item{sku: item.sku, cost: item.cost, qty: item.qty * -1})
    %Cart{items: new_items, total: calculate_total(new_items)}
  end
```

Implement `Cart.calculate_total`:

```
  def calculate_total(items) do
    Enum.reduce(items, 0, fn(item, sum) -> sum + item.cost * item.qty end)
  end
```

Implement `Cart.dedup_items`:

```
  def dedup_items(items, item) do
    case Enum.split_with(items, fn(ea) -> ea.sku == item.sku end) do
      {[], []} -> [item]
      {[], rest} -> [item | rest]
      {[match], rest} -> [%Item{sku: item.sku, qty: item.qty + match.qty, cost: min(item.cost, match.cost)} | rest]
    end
    |> Enum.filter(fn(ea) -> ea.qty > 0 end)
  end
```
