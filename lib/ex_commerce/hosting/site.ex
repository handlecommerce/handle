defmodule ExCommerce.Hosting.Site do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  @type t :: %__MODULE__{
          id: pos_integer(),
          name: String.t(),
          subdomain: String.t() | nil,
          assets: list(ExCommerce.Resources.Asset) | Ecto.Association.NotLoaded.t(),
          routes: list(ExCommerce.Hosting.Route) | Ecto.Association.NotLoaded.t(),
          products: list(ExCommerce.Catalog.Product) | Ecto.Association.NotLoaded.t(),
          archived_at: NaiveDateTime.t() | nil,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "sites" do
    field(:archived_at, :naive_datetime)
    field(:name, :string)
    field(:subdomain, :string)

    has_many(:assets, ExCommerce.Resources.Asset)
    has_many(:routes, ExCommerce.Hosting.Route)
    has_many(:products, ExCommerce.Catalog.Product)

    timestamps()
  end

  @doc false
  def changeset(site, attrs) do
    site
    |> cast(attrs, [:name, :subdomain])
    |> validate_required([:name])
    |> unique_constraint(:subdomain)
  end

  def for_subdomain(queryable \\ __MODULE__, subdomain) do
    from(q in queryable,
      where: q.subdomain == ^subdomain
    )
  end
end
