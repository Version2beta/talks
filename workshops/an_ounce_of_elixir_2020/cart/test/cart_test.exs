defmodule CartTest do
  use ExUnit.Case

  # `show_cart(events)` returning a list of current cart items.
  # Each item in the list should be represented as a list of tuples in the form `{product, {qty, price}}`.
  # An empty cart should return an empty list.

  test "show_cart(events) returns an empty list for an empty cart" do
    events = []
    assert Cart.show_cart(events) == []
  end

  test "show_cart(events) returns an empty list for a cart that has some number of items added and then removed" do
    random_qty = Enum.random(1..100)

    events = [
      {:item_removed, {:dinosaur_egg, random_qty, 125.00}},
      {:item_added, {:dinosaur_egg, random_qty, 125.00}}
    ]

    assert Cart.show_cart(events) == []
  end

  test "show_Cart(events) returns a list of current cart items in the right form" do
    items = [
      {:iguana_leash, {3, 12.00}},
      {:zombie_repellent, {12, 3.00}}
    ]

    events = [
      {:item_added, {:iguana_leash, 3, 12.00}},
      {:item_added, {:zombie_repellent, 12, 3.00}}
    ]

    assert Cart.show_cart(events) == items
  end
end
