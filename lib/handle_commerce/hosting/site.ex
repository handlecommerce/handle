defmodule HandleCommerce.Hosting.Site do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  @type t :: %__MODULE__{
          id: pos_integer(),
          name: String.t(),
          subdomain: String.t() | nil,
          assets: list(HandleCommerce.Resources.Asset) | Ecto.Association.NotLoaded.t(),
          routes: list(HandleCommerce.Hosting.Route) | Ecto.Association.NotLoaded.t(),
          products: list(HandleCommerce.Catalog.Product) | Ecto.Association.NotLoaded.t(),
          archived_at: NaiveDateTime.t() | nil,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "sites" do
    field(:archived_at, :naive_datetime)
    field(:name, :string)
    field(:subdomain, :string)

    has_many(:assets, HandleCommerce.Resources.Asset)
    has_many(:routes, HandleCommerce.Hosting.Route)
    has_many(:products, HandleCommerce.Catalog.Product)

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
