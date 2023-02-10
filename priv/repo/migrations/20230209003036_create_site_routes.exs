defmodule ExCommerce.Repo.Migrations.CreateSiteRoutes do
  use Ecto.Migration

  def change do
    create table(:site_routes) do
      add :path, :string, null: false
      add :archived_at, :naive_datetime
      add :site_id, references(:sites, on_delete: :nothing), null: false
      add :asset_id, references(:assets, on_delete: :nothing)

      timestamps()
    end

    create index(:site_routes, [:site_id, :path], unique: true, where: "archived_at IS NULL")
    create index(:site_routes, [:asset_id])
    create index(:site_routes, [:archived_at])
  end
end
