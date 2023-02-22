# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ExCommerce.Repo.insert!(%ExCommerce.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

{:ok, site} = ExCommerce.Hosting.create_site(%{name: "Winestyr", subdomain: "winestyr"})

{:ok, asset} =
  ExCommerce.Resources.create_text_asset(site, %{
    key: "index.html",
    content: "<h1>Hello World</h1>"
  })

{:ok, route} = ExCommerce.Hosting.create_route(site, %{path: "/", asset_id: asset.id})
