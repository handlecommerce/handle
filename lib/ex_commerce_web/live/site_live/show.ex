defmodule ExCommerceWeb.SiteLive.Show do
  use ExCommerceWeb, :live_view

  alias ExCommerce.Hosting

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:site, Hosting.get_site!(id))}
  end

  defp page_title(:show), do: "Show Site"
  defp page_title(:edit), do: "Edit Site"
end
