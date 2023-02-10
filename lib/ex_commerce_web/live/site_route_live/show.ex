defmodule ExCommerceWeb.SiteRouteLive.Show do
  use ExCommerceWeb, :live_view

  alias ExCommerce.Hosting

  @impl true
  def mount(params, _session, socket) do
    site = Hosting.get_site!(params["site_id"])
    {:ok, assign(socket, :site, site)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:site_route, Hosting.get_site_route!(socket.assigns.site, id))}
  end

  defp page_title(:show), do: "Show Site route"
  defp page_title(:edit), do: "Edit Site route"
end
