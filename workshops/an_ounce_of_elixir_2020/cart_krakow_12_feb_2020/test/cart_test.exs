defmodule CartTest do
  use ExUnit.Case

  test "show_cart(events) returns an empty list for an empty cart" do
    events = []
    assert Cart.show_cart(events) == []
  end

  test "show_card(events) returns an empty list for a cart that has item added and then removed" do
    random_qty = Enum.random(1..100)

    events = [
      {:item_removed, {:dinosaur_egg, random_qty, 125.00}},
      {:item_added, {:dinosaur_egg, random_qty, 125.00}}
    ]

    assert Cart.show_cart(events) == []
  end

  test "show_cart(events) returns a list of current items in the right form" do
    items = [
      {:iguana_leash, {4, 12.00}},
      {:zombie_repelent, {12, 3.00}}
    ]

    events = [
      {:item_added, {:iguana_leash, 3, 12.00}},
      {:item_removed, {:iguana_leash, 1, 12.00}},
      {:item_added, {:iguana_leash, 2, 12.00}},
      {:item_added, {:zombie_repelent, 12, 3.00}}
    ]

    assert Cart.show_cart(events) == items
  end

  test "get_total(events) returns a zero for an empty cart" do
    events = []
    assert Cart.get_total(events) == 0.00
  end

  test "get_total(events) returns a floating point number for the total cost of all products in the cart" do
    events = [
      {:item_added, {:iguana_leash, 3, 12.00}},
      {:item_added, {:zombie_repelent, 12, 3.00}}
    ]

    assert Cart.get_total(events) == 72.00
  end

  test "get_count(events) returns a zero for an empty cart" do
    events = []
    assert Cart.get_count(events) == 0
  end

  test "get_count(events) returns a number of items in a cart" do
    events = [
      {:item_added, {:iguana_leash, 3, 12.00}},
      {:item_added, {:zombie_repelent, 12, 3.00}}
    ]

    assert Cart.get_count(events) == 15
  end

  test "get_added_items(events) returns an empty list for an empty cart" do
    events = []
    assert Cart.get_added_items(events) == []
  end

  test "get_added_items(events) returns an empty list for a cart with only removed items" do
    events = [
      {:item_removed, {:iguana_leash, 3, 12.00}},
      {:item_removed, {:zombie_repelent, 12, 3.00}}
    ]

    assert Cart.get_added_items(events) == []
  end

  test "get_added_items(events) returns a list of added items for a cart" do
    events = [
      {:item_added, {:iguana_leash, 3, 12.00}},
      {:item_removed, {:iguana_leash, 3, 12.00}},
      {:item_added, {:iguana_leash, 3, 12.00}},
      {:item_added, {:zombie_repelent, 12, 3.00}},
      {:item_removed, {:zombie_repelent, 5, 3.00}},
      {:item_added, {:zombie_repelent, 12, 3.00}},
      {:item_added, {:iguana_leash, 3, 12.00}}
    ]

    items = [:iguana_leash, :zombie_repelent, :zombie_repelent, :iguana_leash, :iguana_leash]

    assert Cart.get_added_items(events) == items
  end

  test "get_removed_items(events) returns an empty list for an empty cart" do
    events = []
    assert Cart.get_removed_items(events) == []
  end

  test "get_removed_items(events) returns an empty list for a cart with only added items" do
    events = [
      {:item_added, {:iguana_leash, 3, 12.00}},
      {:item_added, {:zombie_repelent, 12, 3.00}}
    ]

    assert Cart.get_removed_items(events) == []
  end

  test "get_removed_items(events) returns a list of items removed form a cart" do
    events = [
      {:item_added, {:iguana_leash, 3, 12.00}},
      {:item_removed, {:iguana_leash, 3, 12.00}},
      {:item_added, {:iguana_leash, 3, 12.00}},
      {:item_added, {:zombie_repelent, 12, 3.00}},
      {:item_removed, {:zombie_repelent, 5, 3.00}},
      {:item_added, {:zombie_repelent, 12, 3.00}},
      {:item_added, {:iguana_leash, 3, 12.00}}
    ]

    items = [:zombie_repelent, :iguana_leash]

    assert Cart.get_removed_items(events) == items
  end
end
