# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     HandleCommerce.Repo.insert!(%HandleCommerce.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

{:ok, site} = HandleCommerce.Hosting.create_site(%{name: "Winestyr", subdomain: "winestyr"})

{:ok, asset} =
  HandleCommerce.Resources.create_text_asset(site, %{
    key: "index.html",
    content: "<h1>Hello World</h1>"
  })

{:ok, route} = HandleCommerce.Hosting.create_route(site, %{path: "/", asset_id: asset.id})
