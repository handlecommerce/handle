defmodule ExCommerce.Hosting.RouteTest do
  use ExUnit.Case, async: true

  doctest ExCommerce.Hosting.Route
  alias ExCommerce.Hosting.Route

  describe "parse/2" do
    test "parses straight path" do
      assert {:ok, %Route{segments: [segment: ""]}} == Route.parse("")
      assert {:ok, %Route{segments: [segment: ""]}} == Route.parse("/")

      assert {:ok, %Route{segments: [segment: "test"]}} == Route.parse("test")
      assert {:ok, %Route{segments: [segment: "test"]}} == Route.parse("/test")

      assert {:ok, %Route{segments: [segment: "first", segment: "second"]}} ==
               Route.parse("first/second")

      assert {:ok, %Route{segments: [segment: "first", segment: "second"]}} ==
               Route.parse("/first/second")

      assert {:ok, %Route{segments: [segment: "a", segment: "b", segment: "c"]}} ==
               Route.parse("/a/b/c/")
    end

    test "parses params" do
      assert {:ok, %Route{segments: [parameter: "id"]}} == Route.parse("/:id")
      assert {:ok, %Route{segments: [parameter: "id"]}} == Route.parse(":id")

      assert {:ok, %Route{segments: [segment: "products", parameter: "id"]}} ==
               Route.parse("/products/:id")

      assert {:ok, %Route{segments: [segment: "products", parameter: "id"]}} ==
               Route.parse("products/:id")

      assert {:ok, %Route{segments: [segment: "products", parameter: "id", segment: "details"]}} ==
               Route.parse("/products/:id/details")

      assert {:ok, %Route{segments: [segment: "products", parameter: "id", segment: "details"]}} ==
               Route.parse("products/:id/details")
    end

    test "parses glob" do
      assert {:ok, %Route{segments: [glob: "id"]}} == Route.parse("/*id")
      assert {:ok, %Route{segments: [glob: "id"]}} == Route.parse("*id")

      assert {:ok, %Route{segments: [segment: "blog", glob: "slug"]}} ==
               Route.parse("/blog/*slug")

      assert {:ok, %Route{segments: [segment: "blog", glob: "slug"]}} ==
               Route.parse("blog/*slug")
    end

    test "fails to parse if contains glob but not at end of segment list" do
      assert {:error, "Glob matchers must be at the end of the route"} ==
               Route.parse("/a/b/*c/d")
    end
  end

  describe "match/2" do
    test "match path" do
      assert_route("/", "/", %{})
      assert_route("/a/b/c", "/a/b/c", %{})
      assert_route("/products/:id/default", "/products/1234/default/", %{"id" => "1234"})
      assert_route("/blog/*slug", "/blog/2023-01-01/test", %{"slug" => "2023-01-01/test"})
    end

    test "match failures" do
      refute_route("/", "/test")
      refute_route("/a/b/c", "/a/c/c")
      refute_route("/a/b/c", "/a/b")
      refute_route("/:id", "/123/details")
      refute_route("/a/*glob", "/a")
    end
  end

  defp assert_route(left, right, params) do
    {:ok, route} = Route.parse(left)

    assert {:ok, ^params} = Route.match(route, right)
  end

  defp refute_route(left, right) do
    {:ok, route} = Route.parse(left)

    assert :no_match = Route.match(route, right)
  end
end
