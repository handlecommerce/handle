defmodule HandleCommerceWeb.AssetLive.Show do
  use HandleCommerceWeb, :live_view

  alias HandleCommerce.Hosting
  alias HandleCommerce.Resources

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
     |> assign(:asset, Resources.get_asset!(socket.assigns.site, id))}
  end

  defp page_title(:show), do: "Show Asset"
  defp page_title(:edit), do: "Edit Asset"
end
