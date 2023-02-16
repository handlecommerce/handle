defmodule ExCommerce.CatalogTest do
  use ExCommerce.DataCase

  alias ExCommerce.Catalog

  describe "products" do
    alias ExCommerce.Catalog.Product

    import ExCommerce.CatalogFixtures

    @invalid_attrs %{archived_at: nil, description: nil, name: nil}

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Catalog.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Catalog.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{archived_at: ~N[2023-02-15 00:39:00], description: "some description", name: "some name"}

      assert {:ok, %Product{} = product} = Catalog.create_product(valid_attrs)
      assert product.archived_at == ~N[2023-02-15 00:39:00]
      assert product.description == "some description"
      assert product.name == "some name"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      update_attrs = %{archived_at: ~N[2023-02-16 00:39:00], description: "some updated description", name: "some updated name"}

      assert {:ok, %Product{} = product} = Catalog.update_product(product, update_attrs)
      assert product.archived_at == ~N[2023-02-16 00:39:00]
      assert product.description == "some updated description"
      assert product.name == "some updated name"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_product(product, @invalid_attrs)
      assert product == Catalog.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Catalog.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Catalog.change_product(product)
    end
  end
end
