defmodule ExCommerceWeb.EditorLive.Index do
  use ExCommerceWeb, :live_editor

  alias ExCommerce.Resources
  alias ExCommerce.Editor.OpenAsset
  alias ExCommerce.Hosting
  alias ExCommerceWeb.EditorLive.{FileExplorer, FileTabs, Editor}

  @impl true
  def mount(params, _session, socket) do
    site = Hosting.get_site!(params["site_id"])

    {:ok,
     socket
     |> assign(:site, site)
     |> assign(:open_assets, [])
     |> assign(:selected_asset, nil)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex">
      <.live_component module={FileExplorer} id="file-explorer" site={@site} />
      <div class="flex flex-col flex-grow">
        <FileTabs.tabs assets={@open_assets} />
        <.live_component module={Editor} id="file-editor" asset={@selected_asset} />
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("load-file", %{"id" => id}, socket) do
    asset =
      socket.assigns.site
      |> Resources.get_asset!(id)
      |> OpenAsset.new()

    if Enum.any?(socket.assigns.open_assets, &(&1.id == id)) do
      # File is already open
      {:noreply, socket}
    else
      socket = assign(socket, :selected_asset, asset)

      {:noreply,
       socket
       |> assign(
         :open_assets,
         [asset | Enum.reverse(socket.assigns.open_assets)] |> Enum.reverse()
       )}
    end
  end

  def handle_event("close-file", %{"id" => id}, socket) do
    assets = Enum.reject(socket.assigns.open_assets, &(&1.id == id))
    {:noreply, assign(socket, :open_assets, assets)}
  end
end
