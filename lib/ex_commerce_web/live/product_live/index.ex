defmodule ExCommerceWeb.ProductLive.Index do
  use ExCommerceWeb, :live_view

  alias ExCommerce.Catalog
  alias ExCommerce.Catalog.Product
  alias ExCommerce.Hosting

  @impl true
  def mount(params, _session, socket) do
    site = Hosting.get_site!(params["site_id"])

    {:ok,
     socket
     |> assign(:site, site)
     |> assign(:products, list_products(site))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, Catalog.get_product!(socket.assigns.site, id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Product")
    |> assign(:product, %Product{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Products")
    |> assign(:product, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    site = socket.assigns.site

    product = Catalog.get_product!(site, id)
    {:ok, _} = Catalog.archive_product(product)

    {:noreply, assign(socket, :products, list_products(site))}
  end

  defp list_products(site) do
    Catalog.list_products(site)
  end
end
