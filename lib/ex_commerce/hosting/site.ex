defmodule ExCommerce.Hosting.Site do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: pos_integer(),
          name: String.t(),
          subdomain: String.t() | nil,
          archived_at: NaiveDateTime.t() | nil,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "sites" do
    field :archived_at, :naive_datetime
    field :name, :string
    field :subdomain, :string

    timestamps()
  end

  @doc false
  def changeset(site, attrs) do
    site
    |> cast(attrs, [:name, :subdomain])
    |> validate_required([:name])
    |> unique_constraint(:subdomain)
  end
end
