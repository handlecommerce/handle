defmodule HandleCommerceWeb.AssetLive.Index do
  use HandleCommerceWeb, :live_view

  alias HandleCommerce.Hosting
  alias HandleCommerce.Hosting.Site
  alias HandleCommerce.Resources
  alias HandleCommerce.Resources.Asset

  @impl true
  def mount(params, _session, socket) do
    site = Hosting.get_site!(params["site_id"])

    {:ok,
     socket
     |> assign(:site, site)
     |> assign(:assets, list_assets(site))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Asset")
    |> assign(:asset, Resources.get_asset!(socket.assigns.site, id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Asset")
    |> assign(:asset, %Asset{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Assets")
    |> assign(:asset, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    asset = Resources.get_asset!(socket.assigns.site, id)
    {:ok, _} = Resources.delete_asset(asset)

    {:noreply, assign(socket, :assets, list_assets(socket.assigns.site))}
  end

  defp list_assets(%Site{} = site) do
    Resources.list_assets(site)
  end
end
