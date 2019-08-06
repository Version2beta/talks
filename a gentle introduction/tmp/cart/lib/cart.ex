defmodule Cart do
  @moduledoc """
  Documentation for Cart.
  """

  defstruct items: [], total: 0

  defmodule Item do
    defstruct sku: nil, qty: 0, cost: 0
  end

  def process(%Cart{} = cart, events) when is_list(events) do
    Enum.reduce(events, cart, fn(event, cart) -> process(cart, event) end)
  end

  def process(cart, {:item_added, item}) do
    new_items = deduped_items(cart.items, item)
    %Cart{items: new_items, total: calculated_total(new_items)}
  end

  def process(cart, {:item_removed, %Cart.Item{sku: sku, qty: qty, cost: cost}}) do
    new_items = deduped_items(cart.items, %Cart.Item{sku: sku, qty: qty * -1, cost: cost})
    %Cart{items: new_items, total: calculated_total(new_items)}
  end

  def deduped_items(items, item) do
    case Enum.split_with(items, fn(ea) -> ea.sku == item.sku end) do
      {[], unmatched} -> [item | unmatched]
      {[matched], unmatched} -> [%Cart.Item{sku: item.sku, qty: item.qty + matched.qty, cost: min(item.cost, matched.cost)} | unmatched]
    end
    |> Enum.filter(fn(ea) -> ea.qty > 0 end)
  end

  def calculated_total(items) do
    Enum.reduce(items, 0, fn(ea, sum) -> ea.qty * ea.cost + sum end)
  end
end
