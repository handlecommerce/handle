defmodule ExCommerce.ResourcesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExCommerce.Resources` context.
  """

  @doc """
  Generate a asset.
  """
  def asset_fixture(attrs \\ %{}) do
    {:ok, asset} =
      attrs
      |> Enum.into(%{
        archived_at: ~N[2023-02-07 00:45:00],
        content: "some content",
        file_path: "some file_path",
        filename: "some filename"
      })
      |> ExCommerce.Resources.create_asset()

    asset
  end
end