defmodule Cart do
  @moduledoc """
  Documentation for Cart.
  """
  defstruct items: [], total: 0

  defmodule Item do
    defstruct sku: nil, qty: 0, cost: 0
  end

  def process(cart, events) when is_list(events) do
    Enum.reduce(events, cart, fn(event, cart) -> process(cart, event) end)
  end

  def process(%Cart{items: items}, {:item_added, item}) do
    new_items = dedup_items(items, item)
    %Cart{items: new_items, total: calculated_total(new_items)}
  end

  def process(%Cart{items: items}, {:item_removed, item}) do
    new_items = dedup_items(items, %Item{sku: item.sku, qty: item.qty * -1, cost: item.cost})
    %Cart{items: new_items, total: calculated_total(new_items)}
  end

  def calculated_total(items) do
    Enum.reduce(items, 0, fn(item, sum) -> sum + item.cost * item.qty end)
  end

  def dedup_items(items, item) do
    case Enum.split_with(items, fn(ea) -> ea.sku == item.sku end) do
      {[], []} -> [item]
      {[], rest} -> [item | rest]
      {[match], rest} -> [%Item{sku: item.sku, qty: item.qty + match.qty, cost: min(item.cost, match.cost)} | rest]
    end
    |> Enum.filter(fn(ea) -> ea.qty > 0 end)
  end
end
