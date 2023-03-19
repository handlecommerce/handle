defmodule HandleCommerce.Repo.Migrations.AddFieldsToProducts do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :sku, :string
      add :slug, :string
      add :price, :decimal, precision: 15, scale: 2
    end

    create index(:products, [:site_id, :sku], unique: true, where: "archived_at IS NULL")
    create index(:products, [:site_id, :slug], unique: true, where: "archived_at IS NULL")
  end
end
