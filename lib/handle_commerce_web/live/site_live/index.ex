defmodule HandleCommerceWeb.SiteLive.Index do
  use HandleCommerceWeb, :live_view

  alias HandleCommerce.Hosting
  alias HandleCommerce.Hosting.Site

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :sites, list_sites())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Site")
    |> assign(:site, Hosting.get_site!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Site")
    |> assign(:site, %Site{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Sites")
    |> assign(:site, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    site = Hosting.get_site!(id)
    {:ok, _} = Hosting.archive_site(site)

    {:noreply, assign(socket, :sites, list_sites())}
  end

  defp list_sites do
    Hosting.list_sites()
  end
end
