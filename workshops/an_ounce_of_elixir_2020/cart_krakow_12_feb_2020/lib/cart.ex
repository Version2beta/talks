defmodule Cart do
  @moduledoc """
  Documentation for Cart.
  """

  def show_cart(events) when is_list(events) do
    Enum.reverse(events)
    |> Enum.reduce(
      [],
      fn {event, {product, qty, price}}, cart ->
        adjustment = calculate_adjustment(event, qty)
        [{_product, {qty, _price}} | rest] = move_to_head(cart, product)

        [{product, {qty + adjustment, price}} | rest]
        |> remove_item_with_zero_qty()
      end
    )
  end

  def calculate_adjustment(:item_added, qty) do
    qty
  end

  def calculate_adjustment(:item_removed, qty) do
    -1 * qty
  end

  def move_to_head(cart, product) do
    item_to_move = Enum.find(cart, {product, {0, 0.00}}, fn {item, _} -> item == product end)
    rest_of_items = Enum.filter(cart, fn {item, _} -> item != product end)
    [item_to_move | rest_of_items]
  end

  def remove_item_with_zero_qty(cart) do
    Enum.filter(cart, fn {_product, {qty, _price}} -> qty > 0 end)
  end

  def get_total(events) do
    show_cart(events) |> Enum.reduce(0, fn {_product, {qty, price}}, sum -> sum + qty * price end)
  end

  def get_count(events) do
    show_cart(events) |> Enum.reduce(0, fn {_product, {qty, _price}}, sum -> sum + qty end)
  end

  def get_added_items(events) do
    events
    |> Enum.filter(fn {event_type, _} -> event_type == :item_added end)
    |> Enum.reduce([], fn {_event, {product, _, _}}, products -> [product | products] end)
  end

  def get_removed_items(events) do
    events
    |> Enum.filter(fn {event_type, _} -> event_type == :item_removed end)
    |> Enum.reduce([], fn {_event, {product, _, _}}, products -> [product | products] end)
  end
end
