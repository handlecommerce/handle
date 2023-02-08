defmodule ExCommerce.Repo.Migrations.CreateSites do
  use Ecto.Migration

  def change do
    create table(:sites) do
      add :name, :string, null: false
      add :subdomain, :string
      add :archived_at, :naive_datetime

      timestamps()
    end

    create index(:sites, [:name])
    create index(:sites, [:archived_at])
    create unique_index(:sites, [:subdomain])
  end
end
