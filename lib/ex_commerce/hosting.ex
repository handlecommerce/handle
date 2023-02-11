defmodule ExCommerce.Hosting do
  @moduledoc """
  The Hosting context.
  """

  import Ecto.Query, warn: false
  alias ExCommerce.Repo

  alias ExCommerce.Hosting.Site
  alias ExCommerce.Resources.Asset

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

  @spec get_site_by_domain(String.t()) :: Site.t() | nil
  def get_site_by_domain(domain) do
    Site
    |> Repo.unarchived()
    |> Site.for_subdomain(domain)
    |> Repo.one()
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

  alias ExCommerce.Hosting.SiteRoute

  @doc """
  Returns the list of site_routes.

  ## Examples

      iex> list_site_routes(site)
      [%SiteRoute{}, ...]

  """
  def list_site_routes(%Site{} = site) do
    SiteRoute
    |> Repo.unarchived()
    |> SiteRoute.for_site(site)
    |> Repo.all()
  end

  @doc """
  Gets a single site_route.

  Raises `Ecto.NoResultsError` if the Site route does not exist.

  ## Examples

      iex> get_site_route!(site, 123)
      %SiteRoute{}

      iex> get_site_route!(site, 456)
      ** (Ecto.NoResultsError)

  """
  def get_site_route!(%Site{} = site, id) do
    SiteRoute
    |> Repo.unarchived()
    |> SiteRoute.for_site(site)
    |> Repo.get!(id)
  end

  @doc """
  Creates a site_route.

  ## Examples

      iex> create_site_route(site, %{field: value})
      {:ok, %SiteRoute{}}

      iex> create_site_route(site, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_site_route(%Site{} = site, attrs \\ %{}) do
    site
    |> Ecto.build_assoc(:site_routes)
    |> SiteRoute.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a site_route.

  ## Examples

      iex> update_site_route(site_route, %{field: new_value})
      {:ok, %SiteRoute{}}

      iex> update_site_route(site_route, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_site_route(%SiteRoute{} = site_route, attrs) do
    site_route
    |> SiteRoute.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a site_route.

  ## Examples

      iex> delete_site_route(site_route)
      {:ok, %SiteRoute{}}

      iex> delete_site_route(site_route)
      {:error, %Ecto.Changeset{}}

  """
  def archive_site_route(%SiteRoute{} = site_route) do
    Repo.archive(site_route)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking site_route changes.

  ## Examples

      iex> change_site_route(site_route)
      %Ecto.Changeset{data: %SiteRoute{}}

  """
  def change_site_route(%SiteRoute{} = site_route, attrs \\ %{}) do
    SiteRoute.changeset(site_route, attrs)
  end

  @spec get_asset!(Site.t(), String.t()) :: Asset.t()
  def get_asset!(%Site{id: site_id}, route) do
    query =
      from s in SiteRoute,
        join: a in assoc(s, :asset),
        where: s.path == ^(route || "/") and s.site_id == ^site_id,
        select: a

    Repo.one!(query)
  end
end
