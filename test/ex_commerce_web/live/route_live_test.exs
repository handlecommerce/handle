defmodule ExCommerceWeb.RouteLiveTest do
  use ExCommerceWeb.ConnCase

  import Phoenix.LiveViewTest
  import ExCommerce.HostingFixtures

  @create_attrs %{archived_at: "2023-02-08T00:30:00", path: "some path", title: "some title"}
  @update_attrs %{
    archived_at: "2023-02-09T00:30:00",
    path: "some updated path",
    title: "some updated title"
  }
  @invalid_attrs %{archived_at: nil, path: nil, title: nil}

  defp create_route(_) do
    route = route_fixture()
    %{route: route}
  end

  describe "Index" do
    setup [:create_route]

    test "lists all routes", %{conn: conn, route: route} do
      {:ok, _index_live, html} = live(conn, ~p"/routes")

      assert html =~ "Listing Site routes"
      assert html =~ route.path
    end

    test "saves new route", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/routes")

      assert index_live |> element("a", "New Site route") |> render_click() =~
               "New Site route"

      assert_patch(index_live, ~p"/routes/new")

      assert index_live
             |> form("#route-form", route: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#route-form", route: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/routes")

      assert html =~ "Site route created successfully"
      assert html =~ "some path"
    end

    test "updates route in listing", %{conn: conn, route: route} do
      {:ok, index_live, _html} = live(conn, ~p"/routes")

      assert index_live |> element("#routes-#{route.id} a", "Edit") |> render_click() =~
               "Edit Site route"

      assert_patch(index_live, ~p"/routes/#{route}/edit")

      assert index_live
             |> form("#route-form", route: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#route-form", route: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/routes")

      assert html =~ "Site route updated successfully"
      assert html =~ "some updated path"
    end

    test "deletes route in listing", %{conn: conn, route: route} do
      {:ok, index_live, _html} = live(conn, ~p"/routes")

      assert index_live |> element("#routes-#{route.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#route-#{route.id}")
    end
  end

  describe "Show" do
    setup [:create_route]

    test "displays route", %{conn: conn, route: route} do
      {:ok, _show_live, html} = live(conn, ~p"/routes/#{route}")

      assert html =~ "Show Site route"
      assert html =~ route.path
    end

    test "updates route within modal", %{conn: conn, route: route} do
      {:ok, show_live, _html} = live(conn, ~p"/routes/#{route}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Site route"

      assert_patch(show_live, ~p"/routes/#{route}/show/edit")

      assert show_live
             |> form("#route-form", route: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#route-form", route: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/routes/#{route}")

      assert html =~ "Site route updated successfully"
      assert html =~ "some updated path"
    end
  end
end
