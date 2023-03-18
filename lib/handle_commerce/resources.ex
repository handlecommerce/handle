defmodule HandleCommerce.Resources do
  @moduledoc """
  The Resources context.
  """

  import Ecto.Query, warn: false
  alias HandleCommerce.Repo

  alias HandleCommerce.Hosting.Site
  alias HandleCommerce.Resources.Asset

  @doc """
  Returns the list of assets.

  ## Examples

      iex> list_assets(site)
      [%Asset{}, ...]

  """
  def list_assets(%Site{} = site) do
    Asset
    |> Asset.for_site(site)
    |> Repo.unarchived()
    |> Repo.all()
  end

  @doc """
  Gets a single asset.

  Raises `Ecto.NoResultsError` if the Asset does not exist.

  ## Examples

      iex> get_asset!(123)
      %Asset{}

      iex> get_asset!(456)
      ** (Ecto.NoResultsError)

  """
  def get_asset!(%Site{} = site, id) do
    Asset
    |> Asset.for_site(site)
    |> Repo.unarchived()
    |> Repo.get!(id)
  end

  @doc """
  Creates a asset.

  ## Examples

      iex> create_text_asset(site, %{field: value})
      {:ok, %Asset{}}

      iex> create_text_asset(site, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_text_asset(%Site{} = site, attrs \\ %{}) do
    site
    |> Ecto.build_assoc(:assets, %{})
    |> Asset.text_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a asset.

  ## Examples

      iex> update_asset(asset, %{field: new_value})
      {:ok, %Asset{}}

      iex> update_asset(asset, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_text_asset(%Asset{} = asset, attrs) do
    asset
    |> Asset.text_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a asset.

  ## Examples

      iex> delete_asset(asset)
      {:ok, %Asset{}}

      iex> delete_asset(asset)
      {:error, %Ecto.Changeset{}}

  """
  def delete_asset(%Asset{} = asset) do
    Repo.delete(asset)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking asset changes.

  ## Examples

      iex> change_asset(asset)
      %Ecto.Changeset{data: %Asset{}}

  """
  def change_text_asset(%Asset{} = asset, attrs \\ %{}) do
    Asset.text_changeset(asset, attrs)
  end

  def asset_select_options(%Site{} = site, _search \\ "") do
    base_query =
      Asset
      |> Repo.unarchived()
      |> Asset.for_site(site)

    from(q in base_query, select: {q.key, q.id})
    |> Repo.all()
  end
end
