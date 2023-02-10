defmodule ExCommerce.Hosting.SiteRoute do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias ExCommerce.Hosting.Site
  alias ExCommerce.Resources.Asset

  @type t :: %__MODULE__{
          id: pos_integer(),
          path: String.t(),
          site: Site.t() | Ecto.Association.NotLoaded.t(),
          site_id: pos_integer(),
          asset: Asset.t() | nil | Ecto.Association.NotLoaded.t(),
          asset_id: pos_integer(),
          archived_at: NaiveDateTime.t() | nil,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "site_routes" do
    field :path, :string
    belongs_to :site, Site
    belongs_to :asset, Asset

    field :archived_at, :naive_datetime
    timestamps()
  end

  @doc false
  def changeset(site_route, attrs) do
    site_route
    |> cast(attrs, [:path, :asset_id])
    |> validate_required([:path])
  end

  def for_site(queryable \\ __MODULE__, %Site{id: site_id}) do
    from(q in queryable, where: q.site_id == ^site_id)
  end
end
