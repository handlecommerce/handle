defmodule ExCommerce.Hosting do
  @moduledoc """
  The Hosting context.
  """

  import Ecto.Query, warn: false
  alias ExCommerce.Repo

  alias ExCommerce.Hosting.Site

  @doc """
  Returns the list of sites.

  ## Examples

      iex> list_sites()
      [%Site{}, ...]

  """
  def list_sites do
    Site
    |> Repo.unarchived()
    |> Repo.all()
  end

  @doc """
  Gets a single site.

  Raises `Ecto.NoResultsError` if the Site does not exist.

  ## Examples

      iex> get_site!(123)
      %Site{}

      iex> get_site!(456)
      ** (Ecto.NoResultsError)

  """
  def get_site!(id) do
    Site
    |> Repo.unarchived()
    |> Repo.get!(id)
  end

  @doc """
  Creates a site.

  ## Examples

      iex> create_site(%{field: value})
      {:ok, %Site{}}

      iex> create_site(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_site(attrs \\ %{}) do
    %Site{}
    |> Site.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a site.

  ## Examples

      iex> update_site(site, %{field: new_value})
      {:ok, %Site{}}

      iex> update_site(site, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_site(%Site{} = site, attrs) do
    site
    |> Site.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Archives a site.

  ## Examples

      iex> archive_site(site)
      {:ok, %Site{}}

      iex> archive_site(site)
      {:error, %Ecto.Changeset{}}

  """
  def archive_site(%Site{} = site) do
    site
    |> Repo.archive_changeset()
    # Clear out the subdomain on archive
    |> Ecto.Changeset.put_change(:subdomain, nil)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking site changes.

  ## Examples

      iex> change_site(site)
      %Ecto.Changeset{data: %Site{}}

  """
  def change_site(%Site{} = site, attrs \\ %{}) do
    Site.changeset(site, attrs)
  end
end
