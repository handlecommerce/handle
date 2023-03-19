defmodule HandleCommerce.HostingTest do
  use HandleCommerce.DataCase
  import HandleCommerce.Factory

  alias HandleCommerce.Hosting

  import HandleCommerce.TestHelpers

  describe "sites" do
    alias HandleCommerce.Hosting.Site

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

  describe "routes" do
    alias HandleCommerce.Hosting.Route

    @invalid_attrs %{archived_at: nil, path: nil, title: nil}

    test "list_routes/0 returns all routes" do
      route = insert(:route)
      assert records_equal?(Hosting.list_routes(route.site), [route])
    end

    test "get_route!/1 returns the route with given id" do
      route = insert(:route)
      assert records_equal?(Hosting.get_route!(route.site, route.id), route)
    end

    test "create_route/1 with valid data creates a route" do
      site = insert(:site)

      valid_attrs = %{
        path: "some path"
      }

      assert {:ok, %Route{} = route} = Hosting.create_route(site, valid_attrs)
      assert route.path == "some path"
    end

    test "create_route/1 with invalid data returns error changeset" do
      site = insert(:site)
      assert {:error, %Ecto.Changeset{}} = Hosting.create_route(site, @invalid_attrs)
    end

    test "update_route/2 with valid data updates the route" do
      route = insert(:route)

      update_attrs = %{
        path: "some updated path"
      }

      assert {:ok, %Route{} = route} = Hosting.update_route(route, update_attrs)

      assert route.path == "some updated path"
    end

    test "update_route/2 with invalid data returns error changeset" do
      route = insert(:route)
      assert {:error, %Ecto.Changeset{}} = Hosting.update_route(route, @invalid_attrs)
      assert records_equal?(route, Hosting.get_route!(route.site, route.id))
    end

    test "delete_route/1 deletes the route" do
      route = insert(:route)
      assert {:ok, %Route{}} = Hosting.archive_route(route)
      assert_raise Ecto.NoResultsError, fn -> Hosting.get_route!(route.site, route.id) end
    end

    test "change_route/1 returns a route changeset" do
      route = insert(:route)
      assert %Ecto.Changeset{} = Hosting.change_route(route)
    end
  end
end
