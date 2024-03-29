defmodule HandleCommerce.ResourcesTest do
  use HandleCommerce.DataCase
  import HandleCommerce.Factory

  alias HandleCommerce.Resources

  describe "assets" do
    alias HandleCommerce.Resources.Asset

    @invalid_attrs %{key: nil}

    test "list_assets/0 returns all assets" do
      asset = insert(:asset)
      assert Resources.list_assets(asset.site) |> HandleCommerce.Repo.preload(:site) == [asset]
    end

    test "get_asset!/1 returns the asset with given id" do
      asset = insert(:asset)

      assert Resources.get_asset!(asset.site, asset.id) |> HandleCommerce.Repo.preload(:site) ==
               asset
    end

    test "create_text_asset/1 with valid data creates a asset" do
      site = insert(:site)

      valid_attrs = %{
        content: "some content",
        key: "some file_path"
      }

      assert {:ok, %Asset{} = asset} = Resources.create_text_asset(site, valid_attrs)
      assert asset.content == "some content"
      assert asset.key == "some file_path"
    end

    test "create_text_asset/1 with invalid data returns error changeset" do
      site = insert(:site)
      assert {:error, %Ecto.Changeset{}} = Resources.create_text_asset(site, @invalid_attrs)
    end

    test "update_text_asset/2 with valid data updates the asset" do
      asset = insert(:asset)

      update_attrs = %{
        content: "some updated content",
        key: "some updated file_path"
      }

      assert {:ok, %Asset{} = asset} = Resources.update_text_asset(asset, update_attrs)
      assert asset.content == "some updated content"
      assert asset.key == "some updated file_path"
    end

    test "update_text_asset/2 with invalid data returns error changeset" do
      asset = insert(:asset)
      assert {:error, %Ecto.Changeset{}} = Resources.update_text_asset(asset, @invalid_attrs)

      assert asset ==
               Resources.get_asset!(asset.site, asset.id) |> HandleCommerce.Repo.preload(:site)
    end

    test "delete_asset/1 deletes the asset" do
      asset = insert(:asset)
      assert {:ok, %Asset{}} = Resources.delete_asset(asset)
      assert_raise Ecto.NoResultsError, fn -> Resources.get_asset!(asset.site, asset.id) end
    end

    test "change_text_asset/1 returns a asset changeset" do
      asset = insert(:asset)
      assert %Ecto.Changeset{} = Resources.change_text_asset(asset)
    end
  end
end
