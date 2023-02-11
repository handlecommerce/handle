defmodule ExCommerce.Hosting do
  @moduledoc """
  The Hosting context.
  """

  import Ecto.Query, warn: false
  alias ExCommerce.Repo

  alias ExCommerce.Hosting.{Router, Site}
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

  alias ExCommerce.Hosting.Route

  @doc """
  Returns the list of routes.

  ## Examples

      iex> list_routes(site)
      [%Route{}, ...]

  """
  def list_routes(%Site{} = site) do
    Route
    |> Repo.unarchived()
    |> Route.for_site(site)
    |> Repo.all()
  end

  @doc """
  Gets a single route.

  Raises `Ecto.NoResultsError` if the Site route does not exist.

  ## Examples

      iex> get_route!(site, 123)
      %Route{}

      iex> get_route!(site, 456)
      ** (Ecto.NoResultsError)

  """
  def get_route!(%Site{} = site, id) do
    Route
    |> Repo.unarchived()
    |> Route.for_site(site)
    |> Repo.get!(id)
  end

  @doc """
  Creates a route.

  ## Examples

      iex> create_route(site, %{field: value})
      {:ok, %Route{}}

      iex> create_route(site, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_route(%Site{} = site, attrs \\ %{}) do
    Router.reset_for(site)

    site
    |> Ecto.build_assoc(:routes)
    |> Route.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a route.

  ## Examples

      iex> update_route(route, %{field: new_value})
      {:ok, %Route{}}

      iex> update_route(route, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_route(%Route{} = route, attrs) do
    Router.reset_for(route)

    route
    |> Route.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a route.

  ## Examples

      iex> delete_route(route)
      {:ok, %Route{}}

      iex> delete_route(route)
      {:error, %Ecto.Changeset{}}

  """
  def archive_route(%Route{} = route) do
    Router.reset_for(route)

    Repo.archive(route)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking route changes.

  ## Examples

      iex> change_route(route)
      %Ecto.Changeset{data: %Route{}}

  """
  def change_route(%Route{} = route, attrs \\ %{}) do
    Route.changeset(route, attrs)
  end

  @spec get_asset!(Site.t(), String.t()) :: Asset.t()
  def get_asset!(%Site{id: site_id}, route) do
    query =
      from(s in Route,
        join: a in assoc(s, :asset),
        where: s.path == ^(route || "/") and s.site_id == ^site_id,
        select: a
      )

    Repo.one!(query)
  end
end
