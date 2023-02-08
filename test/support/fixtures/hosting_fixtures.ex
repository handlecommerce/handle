defmodule ExCommerce.HostingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExCommerce.Hosting` context.
  """

  @doc """
  Generate a site.
  """
  def site_fixture(attrs \\ %{}) do
    {:ok, site} =
      attrs
      |> Enum.into(%{
        archived_at: ~N[2023-02-06 23:56:00],
        name: "some name",
        subdomain: "some subdomain"
      })
      |> ExCommerce.Hosting.create_site()

    site
  end
end
