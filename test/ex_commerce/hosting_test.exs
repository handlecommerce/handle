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

  describe "site_routes" do
    alias ExCommerce.Hosting.SiteRoute

    import ExCommerce.HostingFixtures

    @invalid_attrs %{archived_at: nil, path: nil, title: nil}

    test "list_site_routes/0 returns all site_routes" do
      site_route = site_route_fixture()
      assert Hosting.list_site_routes() == [site_route]
    end

    test "get_site_route!/1 returns the site_route with given id" do
      site_route = site_route_fixture()
      assert Hosting.get_site_route!(site_route.id) == site_route
    end

    test "create_site_route/1 with valid data creates a site_route" do
      valid_attrs = %{archived_at: ~N[2023-02-08 00:30:00], path: "some path", title: "some title"}

      assert {:ok, %SiteRoute{} = site_route} = Hosting.create_site_route(valid_attrs)
      assert site_route.archived_at == ~N[2023-02-08 00:30:00]
      assert site_route.path == "some path"
      assert site_route.title == "some title"
    end

    test "create_site_route/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Hosting.create_site_route(@invalid_attrs)
    end

    test "update_site_route/2 with valid data updates the site_route" do
      site_route = site_route_fixture()
      update_attrs = %{archived_at: ~N[2023-02-09 00:30:00], path: "some updated path", title: "some updated title"}

      assert {:ok, %SiteRoute{} = site_route} = Hosting.update_site_route(site_route, update_attrs)
      assert site_route.archived_at == ~N[2023-02-09 00:30:00]
      assert site_route.path == "some updated path"
      assert site_route.title == "some updated title"
    end

    test "update_site_route/2 with invalid data returns error changeset" do
      site_route = site_route_fixture()
      assert {:error, %Ecto.Changeset{}} = Hosting.update_site_route(site_route, @invalid_attrs)
      assert site_route == Hosting.get_site_route!(site_route.id)
    end

    test "delete_site_route/1 deletes the site_route" do
      site_route = site_route_fixture()
      assert {:ok, %SiteRoute{}} = Hosting.delete_site_route(site_route)
      assert_raise Ecto.NoResultsError, fn -> Hosting.get_site_route!(site_route.id) end
    end

    test "change_site_route/1 returns a site_route changeset" do
      site_route = site_route_fixture()
      assert %Ecto.Changeset{} = Hosting.change_site_route(site_route)
    end
  end
end
