defmodule HandleCommerceWeb.PageController do
  use HandleCommerceWeb, :controller

  alias HandleCommerce.Hosting.Router
  alias HandleCommerce.Resources

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def show(conn, %{"path" => path} = _params) do
    site = conn.assigns.current_site

    case Router.get_route(site, path) do
      {route, params} ->
        asset = Resources.get_asset!(site, route.asset_id)

        {content, _} =
          asset.content
          |> Liquex.parse!()
          |> Liquex.render!(%{params: params})

        html(conn, content)

      _ ->
        conn
        |> Plug.Conn.put_status(:not_found)
        |> html("Not Found")
    end
  end
end
