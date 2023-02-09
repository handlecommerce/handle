defmodule ExCommerce.Resources.Asset do
  use Ecto.Schema
  import Ecto.Changeset

  import Ecto.Query, only: [from: 2]

  alias ExCommerce.Hosting.Site

  @type t :: %__MODULE__{
          id: pos_integer(),
          key: String.t(),
          content: String.t() | nil,
          site: Site.t(),
          site_id: pos_integer(),
          archived_at: NaiveDateTime.t() | nil,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "assets" do
    field(:key, :string)
    field(:content, :string)
    belongs_to(:site, Site)

    field(:archived_at, :naive_datetime)
    timestamps()
  end

  @doc false
  def changeset(asset, attrs) do
    asset
    |> cast(attrs, [:content, :key])
    |> validate_required([:key])
  end

  def for_site(queryable \\ __MODULE__, %Site{id: site_id}) do
    from(q in queryable, where: q.site_id == ^site_id)
  end
end
