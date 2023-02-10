defmodule ExCommerceWeb.SiteRouteLive.Index do
  use ExCommerceWeb, :live_view

  alias ExCommerce.Hosting
  alias ExCommerce.Hosting.{Site, SiteRoute}

  @impl true
  def mount(params, _session, socket) do
    site = Hosting.get_site!(params["site_id"])

    {:ok,
     socket
     |> assign(:site, site)
     |> assign(:site_routes, list_site_routes(site))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Site route")
    |> assign(:site_route, Hosting.get_site_route!(socket.assigns.site, id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Site route")
    |> assign(:site_route, %SiteRoute{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Site routes")
    |> assign(:site_route, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    site = socket.assigns.site

    site_route = Hosting.get_site_route!(site, id)
    {:ok, _} = Hosting.archive_site_route(site_route)

    {:noreply, assign(socket, :site_routes, list_site_routes(site))}
  end

  defp list_site_routes(%Site{} = site) do
    Hosting.list_site_routes(site)
  end
end
