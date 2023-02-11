defmodule ExCommerce.Hosting.Route do
  defstruct [:segments]

  @type segment_t :: {:parameter, String.t()} | {:segment, String.t()} | {:glob, String.t()}

  @type t :: %__MODULE__{segments: [segment_t()]}

  @spec parse(String.t()) :: {:ok, t()} | {:error, String.t()}
  @doc """
  Parse a route string into the pattern matching segments

      iex> ExCommerce.Hosting.Route.parse("/")
      {:ok, %ExCommerce.Hosting.Route{segments: [segment: ""]}}

  Segments can be deeply nested too.

      iex> ExCommerce.Hosting.Route.parse("/a/b/c")
      {:ok, %ExCommerce.Hosting.Route{segments: [segment: "a", segment: "b", segment: "c"]}}

  Matching parameters is done by a leading colon ":"

      iex> ExCommerce.Hosting.Route.parse("/products/:id/details")
      {:ok,
      %ExCommerce.Hosting.Route{
        segments: [segment: "products", parameter: "id", segment: "details"]
      }}

  Glob matching can be done to capture the rest of the URL if necessary

      iex> ExCommerce.Hosting.Route.parse("/blog/*id")
      {:ok, %ExCommerce.Hosting.Route{segments: [segment: "blog", glob: "id"]}}

  However, the glob match must come a the end of a parsed route, otherwise
  you will receive an error.

      iex> ExCommerce.Hosting.Route.parse("/blog/*id/remaining")
      {:error, "Glob matchers must be at the end of the route"}
  """
  def parse(route) do
    route
    |> String.trim("/")
    |> String.split("/")
    |> Enum.map(&categorize_segment/1)
    |> verify_segments()
  end

  @spec match(t(), String.t()) :: {:ok, map} | :no_match
  def match(%__MODULE__{segments: segments}, path) do
    path_segments =
      path
      |> String.trim("/")
      |> String.split("/")

    do_match(segments, path_segments)
  end

  defp do_match(params \\ %{}, segments, path_segments)

  # Nothing remaining to match, so this is a success
  defp do_match(params, [], []), do: {:ok, params}

  # Current segment matches the path segment
  defp do_match(params, [{:segment, segment} | segments], [segment | path_segments]),
    do: do_match(params, segments, path_segments)

  defp do_match(params, [{:parameter, identifier} | segments], [segment | path_segments]) do
    params
    |> Map.put(identifier, segment)
    |> do_match(segments, path_segments)
  end

  defp do_match(params, [{:glob, identifier} | []], [_ | _] = path_segments) do
    params = Map.put(params, identifier, Enum.join(path_segments, "/"))

    {:ok, params}
  end

  defp do_match(_, _, _), do: :no_match

  defp categorize_segment(":" <> identifier), do: {:parameter, identifier}
  defp categorize_segment("*" <> identifier), do: {:glob, identifier}
  defp categorize_segment(identifier), do: {:segment, identifier}

  # Verify that the segments will properly match
  #
  # Makes sure that if a glob matcher exists, that it is only at the end of
  # the list of segments
  defp verify_segments(segments) do
    segment_count = Enum.count(segments)
    glob_index = Enum.find_index(segments, &(elem(&1, 0) == :glob))

    if is_nil(glob_index) || glob_index == segment_count - 1 do
      {:ok, %__MODULE__{segments: segments}}
    else
      {:error, "Glob matchers must be at the end of the route"}
    end
  end
end
