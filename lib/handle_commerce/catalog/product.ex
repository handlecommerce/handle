defmodule HandleCommerce.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias HandleCommerce.Hosting.Site

  schema "products" do
    field :archived_at, :naive_datetime
    field :description, :string
    field :name, :string
    field :site_id, :id

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
  end

  def for_site(queryable \\ __MODULE__, %Site{id: site_id}) do
    from(q in queryable, where: q.site_id == ^site_id)
  end
end
