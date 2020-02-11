defmodule Cart do
  def show_cart(events) do
    Enum.reduce(
      events,
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

  def get_total(events) do
    cart = show_cart(events)

    Enum.reduce(cart, 0.00, fn {_product, {qty, price}}, total ->
      total + qty * price
    end)
  end

  def count_items(events) do
    cart = show_cart(events)
    Enum.reduce(cart, 0, fn {_product, {qty, _price}}, count -> count + qty end)
  end

  def get_added_items(events) do
    Enum.filter(events, fn {event_type, _} -> event_type == :item_added end)
    |> Enum.map(fn {_, {product, _, _}} -> product end)
  end

  def get_removed_items(events) do
    Enum.filter(events, fn {event_type, _} -> event_type == :item_removed end)
    |> Enum.map(fn {_, {product, _, _}} -> product end)
  end
end
