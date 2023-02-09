defmodule ExCommerce.Repo.Migrations.CreateAssets do
  use Ecto.Migration

  def change do
    create table(:assets) do
      add :content, :string
      add :key, :string, null: false
      add :site_id, references(:sites, on_delete: :nothing), null: false

      add :archived_at, :naive_datetime
      timestamps()
    end

    create index(:assets, [:site_id])
    create index(:assets, [:key])
    create index(:assets, [:archived_at])
  end
end
