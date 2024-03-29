defmodule HandleCommerce.Catalog do
  @moduledoc """
  The Catalog context.
  """

  import Ecto.Query, warn: false
  alias HandleCommerce.Repo

  alias HandleCommerce.Catalog.Product
  alias HandleCommerce.Hosting.Site

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products(%Site{} = site) do
    Product
    |> Repo.unarchived()
    |> Product.for_site(site)
    |> Repo.all()
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(site, 123)
      %Product{}

      iex> get_product!(site, 456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(%Site{} = site, id) do
    Product
    |> Repo.unarchived()
    |> Product.for_site(site)
    |> Repo.get!(id)
  end

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(site, %{field: value})
      {:ok, %Product{}}

      iex> create_product(site, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(%Site{} = site, attrs \\ %{}) do
    site
    |> Ecto.build_assoc(:products)
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Archives a product.

  ## Examples

      iex> archive_product(product)
      {:ok, %Product{}}

      iex> archive_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def archive_product(%Product{} = product) do
    Repo.archive(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end
end
