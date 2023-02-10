defmodule ExCommerceWeb.SiteRouteLive.FormComponent do
  use ExCommerceWeb, :live_component

  alias ExCommerce.Hosting

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage site_route records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="site_route-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :path}} type="text" label="Path" />
        <.input field={{f, :asset_id}} type="select" options={@assets} label="Asset" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Site route</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{site_route: site_route} = assigns, socket) do
    changeset = Hosting.change_site_route(site_route)

    assets = ExCommerce.Resources.asset_select_options(assigns.site)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:assets, assets)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"site_route" => site_route_params}, socket) do
    changeset =
      socket.assigns.site_route
      |> Hosting.change_site_route(site_route_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"site_route" => site_route_params}, socket) do
    save_site_route(socket, socket.assigns.action, site_route_params)
  end

  defp save_site_route(socket, :edit, site_route_params) do
    case Hosting.update_site_route(socket.assigns.site_route, site_route_params) do
      {:ok, _site_route} ->
        {:noreply,
         socket
         |> put_flash(:info, "Site route updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_site_route(socket, :new, site_route_params) do
    case Hosting.create_site_route(socket.assigns.site, site_route_params) do
      {:ok, _site_route} ->
        {:noreply,
         socket
         |> put_flash(:info, "Site route created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
