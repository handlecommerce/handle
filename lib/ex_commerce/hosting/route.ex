defmodule ExCommerce.Hosting.Route do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias ExCommerce.Hosting.Site
  alias ExCommerce.Resources.Asset

  @type segment_t :: {:parameter, String.t()} | {:segment, String.t()} | {:glob, String.t()}

  @type t :: %__MODULE__{
          id: pos_integer(),
          path: String.t(),
          site: Site.t() | Ecto.Association.NotLoaded.t(),
          site_id: pos_integer(),
          asset: Asset.t() | nil | Ecto.Association.NotLoaded.t(),
          asset_id: pos_integer(),
          segments: [segment_t] | nil,
          archived_at: NaiveDateTime.t() | nil,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "routes" do
    field(:path, :string)
    belongs_to(:site, Site)
    belongs_to(:asset, Asset)

    # TODO: Update this to a custom type
    field(:segments, :string, virtual: true)

    field(:archived_at, :naive_datetime)
    timestamps()
  end

  @doc false
  def changeset(route, attrs) do
    route
    |> cast(attrs, [:path, :asset_id])
    |> validate_required([:path])
  end

  def for_site(queryable \\ __MODULE__, %Site{id: site_id}) do
    from(q in queryable, where: q.site_id == ^site_id)
  end

  @spec with_segments([t]) :: [t]
  def with_segments(routes) when is_list(routes) do
    routes
    |> Enum.map(fn route ->
      {:ok, segments} = parse(route.path)
      %{route | segments: segments}
    end)
  end

  @spec parse(String.t()) :: {:ok, [segment_t]} | {:error, String.t()}
  @doc """
  Parse a route string into the pattern matching segments

      iex> ExCommerce.Hosting.Route.parse("/")
      {:ok, %ExCommerce.Hosting.Route{segments: []}}

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
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&categorize_segment/1)
    |> verify_segments()
  end

  @spec match(t(), String.t()) :: {:ok, map} | :no_match | {:error, String.t()}
  def match(%__MODULE__{segments: segments}, path_segments) do
    do_match(segments, path_segments)
  end

  defp do_match(params \\ %{}, segments, path_segments)

  # Segments are not loaded yet
  defp do_match(_params, nil, _),
    do: {:error, "Route segments not loaded. Please call with_segments/1"}

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
      {:ok, segments}
    else
      {:error, "Glob matchers must be at the end of the route"}
    end
  end
end
