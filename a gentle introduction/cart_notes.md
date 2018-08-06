## Live coding in the REPL


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
