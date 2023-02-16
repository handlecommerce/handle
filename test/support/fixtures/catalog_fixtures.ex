defmodule ExCommerce.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExCommerce.Catalog` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        archived_at: ~N[2023-02-15 00:39:00],
        description: "some description",
        name: "some name"
      })
      |> ExCommerce.Catalog.create_product()

    product
  end
end
