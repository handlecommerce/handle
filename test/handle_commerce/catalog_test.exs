defmodule HandleCommerce.CatalogTest do
  use HandleCommerce.DataCase

  alias HandleCommerce.Catalog

  describe "products" do
    alias HandleCommerce.Catalog.Product
    import HandleCommerce.Factory
    import HandleCommerce.TestHelpers

    @invalid_attrs %{archived_at: nil, description: nil, name: nil}

    test "list_products/0 returns all products" do
      product = insert(:product)
      assert records_equal?(Catalog.list_products(product.site), [product])
    end

    test "get_product!/1 returns the product with given id" do
      product = insert(:product)
      assert records_equal?(Catalog.get_product!(product.site, product.id), product)
    end

    test "create_product/1 with valid data creates a product" do
      site = insert(:site)

      valid_attrs = %{
        description: "some description",
        name: "some name"
      }

      assert {:ok, %Product{} = product} = Catalog.create_product(site, valid_attrs)
      assert product.description == "some description"
      assert product.name == "some name"
    end

    test "create_product/1 with invalid data returns error changeset" do
      site = insert(:site)
      assert {:error, %Ecto.Changeset{}} = Catalog.create_product(site, @invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = insert(:product)

      update_attrs = %{
        description: "some updated description",
        name: "some updated name"
      }

      assert {:ok, %Product{} = product} = Catalog.update_product(product, update_attrs)
      assert product.description == "some updated description"
      assert product.name == "some updated name"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = insert(:product)
      assert {:error, %Ecto.Changeset{}} = Catalog.update_product(product, @invalid_attrs)
      assert records_equal?(product, Catalog.get_product!(product.site, product.id))
    end

    test "delete_product/1 deletes the product" do
      product = insert(:product)
      assert {:ok, %Product{}} = Catalog.archive_product(product)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_product!(product.site, product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = insert(:product)
      assert %Ecto.Changeset{} = Catalog.change_product(product)
    end
  end
end
