defmodule CartTest do
  use ExUnit.Case

  @some_events [
    {:item_added, %Cart.Item{sku: :nail_polish_elephant, qty: 1, cost: 9.99}},
    {:item_added, %Cart.Item{sku: :pumice_stone, qty: 10, cost: 2.79}},
    {:item_added, %Cart.Item{sku: :nail_file_xl, qty: 1, cost: 14.69}},
    {:item_added, %Cart.Item{sku: :nail_polish_elephant, qty: 3, cost: 9.99}},
    {:item_removed, %Cart.Item{sku: :pumice_stone, qty: 10, cost: 2.79}},
    {:item_added, %Cart.Item{sku: :pumice_stone_xl, qty: 1, cost: 7.79}},
  ]

  @expected_result %Cart{items: [
    %Cart.Item{sku: :nail_polish_elephant, qty: 4, cost: 9.99},
    %Cart.Item{sku: :nail_file_xl, qty: 1, cost: 14.69},
    %Cart.Item{sku: :pumice_stone_xl, qty: 1, cost: 7.79},
  ], total: 62.44}

  test "Processing some events gives us our expected cart" do
    result = Cart.process(%Cart{}, @some_events)
    assert result.total == @expected_result.total
    assert Enum.count(result.items) == 3
    assert @expected_result.items -- result.items == result.items -- @expected_result.items
  end
end
