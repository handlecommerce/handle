defmodule HandleCommerce.Hosting.RouteTest do
  use ExUnit.Case, async: true

  doctest HandleCommerce.Hosting.Route
  alias HandleCommerce.Hosting.Route

  describe "parse/2" do
    test "parses straight path" do
      assert {:ok, %Route{segments: []}} == Route.parse("")
      assert {:ok, %Route{segments: []}} == Route.parse("/")

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
      assert_route("/", [], %{})
      assert_route("/a/b/c", ~w(a b c), %{})
      assert_route("/products/:id/default", ~w(products 1234 default), %{"id" => "1234"})
      assert_route("/blog/*slug", ~w(blog 2023-01-01 test), %{"slug" => "2023-01-01/test"})
    end

    test "match failures" do
      refute_route("/", ~w("test"))
      refute_route("/a/b/c", ~w(a c c))
      refute_route("/a/b/c", ~w(a b))
      refute_route("/:id", ~w(123 details))
      refute_route("/a/*glob", ~w(a))
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
