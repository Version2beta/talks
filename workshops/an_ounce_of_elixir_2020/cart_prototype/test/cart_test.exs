defmodule CartTest do
  use ExUnit.Case

  # `show_cart(events)` returning a list of current cart items.
  # Each item in the list should be represented as a list of tuples in the form `{product, {qty, price}}`.
  # An empty cart should return an empty list.

  test "show_cart returns an empty list when it receives no events" do
    events = []
    assert Cart.show_cart(events) == []
  end

  test "show_cart returns an empty list if an item in any quantity is added and then the same qty is removed" do
    random_qty = Enum.random(1..100)

    events = [
      {:item_removed, {:dinosaur_egg, random_qty, 125.00}},
      {:item_added, {:dinosaur_egg, random_qty, 125.00}}
    ]

    assert Cart.show_cart(events) == []
  end

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

  # `get_total(events)` returning a floating point number representing the total value of all products in the final cart.
  # The total for an empty cart should be 0.00.

  test "get_total(events) returns zero for an empty cart" do
    events = []
    assert Cart.get_total(events) == 0.00
  end

  test "get_total(events) returns a floating point number for the total value of all products in the final cart" do
    events = [
      {:item_added, {:iguana_leash, 3, 12.00}},
      {:item_added, {:zombie_repellent, 12, 3.00}}
    ]

    assert Cart.get_total(events) == 72.00
  end

  # `count_items(events)` returning a count of current cart items.
  # An empty cart should return 0.

  test "count_items(events) returns zero for an empty cart" do
    events = []
    assert Cart.count_items(events) == 0
  end

  test "count_items(events) returns a count of items in a cart" do
    events = [
      {:item_added, {:iguana_leash, 3, 12.00}},
      {:item_added, {:zombie_repellent, 12, 3.00}}
    ]

    assert Cart.count_items(events) == 15
  end

  # `get_added_items(events)` returns a list of all products added to a cart
  # - regardless of whether they were later removed
  # - in chronological order with the most recently added item at the head of the list
  # If no items were added, the returned list should be empty.

  test "get_added_items returns an empty list if no items have been added" do
    events = []
    assert Cart.get_added_items(events) == []
  end

  test "get_added_items returns a list of added items in the right order" do
    events_forward = [
      {:item_added, {:iguana_leash, 3, 12.00}},
      {:item_added, {:zombie_repellent, 12, 3.00}}
    ]

    events_backward = [
      {:item_added, {:zombie_repellent, 12, 3.00}},
      {:item_added, {:iguana_leash, 3, 12.00}}
    ]

    assert Cart.get_added_items(events_forward) == [:iguana_leash, :zombie_repellent]

    assert Cart.get_added_items(events_backward) == [:zombie_repellent, :iguana_leash]
  end

  # `get_removed_items(events)` returns a list of all products removed from a cart
  # - regardless of whether they were later re-added
  # - in chronological order with the most recently removed item at the head of the list
  # If no items were removed, the returned list should be empty.

  test "get_removed_items returns an empty list if no items have been removed" do
    events = []
    assert Cart.get_removed_items(events) == []
  end

  test "get_removed_items returns a list of removed items in the right order" do
    events_forward = [
      {:item_added, {:iguana_leash, 3, 12.00}},
      {:item_added, {:zombie_repellent, 12, 3.00}},
      {:item_added, {:dinosaur_egg, 1, 145.00}},
      {:item_removed, {:iguana_leash, 3, 12.00}},
      {:item_removed, {:zombie_repellent, 12, 3.00}}
    ]

    assert Cart.get_removed_items(events_forward) == [:iguana_leash, :zombie_repellent]

    events_backward = [
      {:item_added, {:dinosaur_egg, 1, 145.00}},
      {:item_added, {:zombie_repellent, 12, 3.00}},
      {:item_added, {:iguana_leash, 3, 12.00}},
      {:item_removed, {:zombie_repellent, 12, 3.00}},
      {:item_removed, {:iguana_leash, 3, 12.00}}
    ]

    assert Cart.get_removed_items(events_backward) == [:zombie_repellent, :iguana_leash]
  end
end
