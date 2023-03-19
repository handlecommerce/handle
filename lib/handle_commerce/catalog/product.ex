defmodule HandleCommerce.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias HandleCommerce.Hosting.Site

  @type t :: %__MODULE__{
          id: pos_integer(),
          name: String.t(),
          description: String.t() | nil,
          price: Decimal.t(),
          site: Site.t(),
          sku: String.t() | nil,
          slug: String.t() | nil,
          archived_at: NaiveDateTime.t() | nil,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "products" do
    field :archived_at, :naive_datetime
    field :description, :string
    field :name, :string
    belongs_to :site, Site
    field :sku, :string
    field :slug, :string
    field :price, :decimal

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :sku, :slug, :price])
    |> validate_required([:name])
    |> foreign_key_constraint(:site_id)
    |> unique_constraint([:site_id, :sku], name: :products_sku_site_id_index)
    |> unique_constraint([:site_id, :slug], name: :products_slug_site_id_index)
  end

  def for_site(queryable \\ __MODULE__, %Site{id: site_id}) do
    from(q in queryable, where: q.site_id == ^site_id)
  end
end
