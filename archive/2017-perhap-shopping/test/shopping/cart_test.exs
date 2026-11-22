defmodule ShoppingTest.Cart do
  use ExUnit.Case, async: true

  test "handles an added item" do
    empty_cart = %Shopping.Cart{ id: Perhap.Event.get_uuid_v4() }
    product = %{ "item_id" => Perhap.Event.get_uuid_v4(), "item" => "testable", "quantity" => 1, "price" => 0.99 }
    event = %{ data: product }
    { cart, [] } = Shopping.Cart.reducer(:item_added, empty_cart, event)
    assert cart.items ==
      %{ product["item_id"] => %{ item: product["item"], quantity: product["quantity"], price: product["price"] } }
  end

  test "calculates the price" do
    empty_cart = %Shopping.Cart{ id: Perhap.Event.get_uuid_v4() }
    product1 = %{ "item_id" => Perhap.Event.get_uuid_v4(), "item" => "testable", "quantity" => 2, "price" => 0.99 }
    product2 = %{ "item_id" => Perhap.Event.get_uuid_v4(), "item" => "testable2", "quantity" => 3, "price" => 0.69 }
    { cart1, [] } = Shopping.Cart.reducer(:item_added, empty_cart, %{ data: product1 })
    assert cart1.total == 2 * 0.99
    { cart2, [] } = Shopping.Cart.reducer(:item_added, cart1, %{ data: product2 })
    assert cart2.total == 2 * 0.99 + 3 * 0.69
  end
end
