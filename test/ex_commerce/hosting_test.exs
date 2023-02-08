defmodule ExCommerce.HostingTest do
  use ExCommerce.DataCase
  import ExCommerce.Factory

  alias ExCommerce.Hosting

  describe "sites" do
    alias ExCommerce.Hosting.Site

    @invalid_attrs %{archived_at: nil, name: nil, subdomain: nil}

    test "list_sites/0 returns all sites" do
      site = insert(:site)
      assert Hosting.list_sites() == [site]
    end

    test "get_site!/1 returns the site with given id" do
      site = insert(:site)
      assert Hosting.get_site!(site.id) == site
    end

    test "create_site/1 with valid data creates a site" do
      valid_attrs = %{
        name: "some name",
        subdomain: "some subdomain"
      }

      assert {:ok, %Site{} = site} = Hosting.create_site(valid_attrs)
      assert site.name == "some name"
      assert site.subdomain == "some subdomain"
    end

    test "create_site/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Hosting.create_site(@invalid_attrs)
    end

    test "update_site/2 with valid data updates the site" do
      site = insert(:site)

      update_attrs = %{
        name: "some updated name",
        subdomain: "some updated subdomain"
      }

      assert {:ok, %Site{} = site} = Hosting.update_site(site, update_attrs)
      assert site.name == "some updated name"
      assert site.subdomain == "some updated subdomain"
    end

    test "update_site/2 with invalid data returns error changeset" do
      site = insert(:site)
      assert {:error, %Ecto.Changeset{}} = Hosting.update_site(site, @invalid_attrs)
      assert site == Hosting.get_site!(site.id)
    end

    test "archive_site/1 archives the site" do
      site = insert(:site)
      assert {:ok, %Site{}} = Hosting.archive_site(site)
      assert_raise Ecto.NoResultsError, fn -> Hosting.get_site!(site.id) end
    end

    test "archive_site/1 allows reuse of the subdomain" do
      site = insert(:site)
      assert {:ok, %Site{}} = Hosting.archive_site(site)

      insert(:site, subdomain: site.subdomain)
    end

    test "change_site/1 returns a site changeset" do
      site = insert(:site)
      assert %Ecto.Changeset{} = Hosting.change_site(site)
    end
  end
end
