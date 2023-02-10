defmodule ExCommerceWeb.SiteRouteLiveTest do
  use ExCommerceWeb.ConnCase

  import Phoenix.LiveViewTest
  import ExCommerce.HostingFixtures

  @create_attrs %{archived_at: "2023-02-08T00:30:00", path: "some path", title: "some title"}
  @update_attrs %{archived_at: "2023-02-09T00:30:00", path: "some updated path", title: "some updated title"}
  @invalid_attrs %{archived_at: nil, path: nil, title: nil}

  defp create_site_route(_) do
    site_route = site_route_fixture()
    %{site_route: site_route}
  end

  describe "Index" do
    setup [:create_site_route]

    test "lists all site_routes", %{conn: conn, site_route: site_route} do
      {:ok, _index_live, html} = live(conn, ~p"/site_routes")

      assert html =~ "Listing Site routes"
      assert html =~ site_route.path
    end

    test "saves new site_route", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/site_routes")

      assert index_live |> element("a", "New Site route") |> render_click() =~
               "New Site route"

      assert_patch(index_live, ~p"/site_routes/new")

      assert index_live
             |> form("#site_route-form", site_route: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#site_route-form", site_route: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/site_routes")

      assert html =~ "Site route created successfully"
      assert html =~ "some path"
    end

    test "updates site_route in listing", %{conn: conn, site_route: site_route} do
      {:ok, index_live, _html} = live(conn, ~p"/site_routes")

      assert index_live |> element("#site_routes-#{site_route.id} a", "Edit") |> render_click() =~
               "Edit Site route"

      assert_patch(index_live, ~p"/site_routes/#{site_route}/edit")

      assert index_live
             |> form("#site_route-form", site_route: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#site_route-form", site_route: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/site_routes")

      assert html =~ "Site route updated successfully"
      assert html =~ "some updated path"
    end

    test "deletes site_route in listing", %{conn: conn, site_route: site_route} do
      {:ok, index_live, _html} = live(conn, ~p"/site_routes")

      assert index_live |> element("#site_routes-#{site_route.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#site_route-#{site_route.id}")
    end
  end

  describe "Show" do
    setup [:create_site_route]

    test "displays site_route", %{conn: conn, site_route: site_route} do
      {:ok, _show_live, html} = live(conn, ~p"/site_routes/#{site_route}")

      assert html =~ "Show Site route"
      assert html =~ site_route.path
    end

    test "updates site_route within modal", %{conn: conn, site_route: site_route} do
      {:ok, show_live, _html} = live(conn, ~p"/site_routes/#{site_route}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Site route"

      assert_patch(show_live, ~p"/site_routes/#{site_route}/show/edit")

      assert show_live
             |> form("#site_route-form", site_route: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#site_route-form", site_route: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/site_routes/#{site_route}")

      assert html =~ "Site route updated successfully"
      assert html =~ "some updated path"
    end
  end
end
