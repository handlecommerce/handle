defmodule HandleCommerce.ResourcesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `HandleCommerce.Resources` context.
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
      |> HandleCommerce.Resources.create_text_asset()

    asset
  end
end
