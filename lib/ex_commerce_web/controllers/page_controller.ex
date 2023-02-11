defmodule ExCommerceWeb.PageController do
  use ExCommerceWeb, :controller

  alias ExCommerce.Hosting

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def show(conn, %{"path" => paths} = _params) do
    path = List.first(paths)
    asset = Hosting.get_asset!(conn.assigns.current_site, path)

    html(conn, asset.content)
  end
end
