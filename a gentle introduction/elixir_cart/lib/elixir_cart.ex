defmodule ElixirCart do
  @moduledoc """
  Documentation for ElixirCart.
  """

  def cart(cart, {:add, %{sku => {qty, cost}} = item}) do
  end

  def cart(cart, {:remove, %{sku => {qty, cost}} = item}) do
  end
end
