defmodule ExCommerce.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string, null: false
      add :description, :text
      add :archived_at, :naive_datetime
      add :site_id, references(:sites, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:products, [:site_id])
    create index(:products, [:name])
    create index(:products, [:archived_at])
  end
end
