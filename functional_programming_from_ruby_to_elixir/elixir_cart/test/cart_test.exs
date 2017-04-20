defmodule CartTest do
  use ExUnit.Case
  doctest Cart

  def cartShouldContain do
    [
      :organic_twinkies,
      :elephant_food,
      :cummerbund,
      :hula_hoop,
      :hydrofluoric_acid
    ] |> Enum.sort
  end

  def cartTestEvents do
    [ { :add,
        :organic_twinkies,
        DateTime.from_iso8601("2017-04-20T13:12:00Z") },
      { :add,
        :elephant_food,
        DateTime.from_iso8601("2017-04-20T13:15:00Z") },
      { :add,
        :toenail_polish,
        DateTime.from_iso8601("2017-04-20T13:16:00Z") },
      { :add,
        :cummerbund,
        DateTime.from_iso8601("2017-04-20T13:19:00Z") },
      { :remove,
        :toenail_polish,
        DateTime.from_iso8601("2017-04-20T13:25:00Z") },
      { :add,
        :hula_hoop,
        DateTime.from_iso8601("2017-04-20T13:26:00Z") },
      { :add,
        :hula_hoop,
        DateTime.from_iso8601("2017-04-20T13:26:02Z") },
      { :add,
        :hydrofluoric_acid,
        DateTime.from_iso8601("2017-04-20T13:29:00Z") },
      { :remove,
        :hula_hoop,
        DateTime.from_iso8601("2017-04-20T13:31:00Z") }
    ]
  end

  test "cart contains all the right stuff" do
    assert Cart.contents(cartTestEvents()) == cartShouldContain()
  end
end
