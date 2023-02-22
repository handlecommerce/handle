defmodule ExCommerceWeb.EditorLive.Index do
  use ExCommerceWeb, :live_view

  alias ExCommerce.Hosting
  alias ExCommerceWeb.EditorLive.FileExplorer

  @impl true
  def mount(params, _session, socket) do
    site = Hosting.get_site!(params["site_id"])

    {:ok, socket |> assign(:site, site)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.live_component module={FileExplorer} id="hero" site={@site} />
    """
  end
end
