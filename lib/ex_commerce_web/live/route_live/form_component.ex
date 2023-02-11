defmodule ExCommerceWeb.RouteLive.FormComponent do
  use ExCommerceWeb, :live_component

  alias ExCommerce.Hosting

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage route records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="route-form"
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
  def update(%{route: route} = assigns, socket) do
    changeset = Hosting.change_route(route)

    assets = ExCommerce.Resources.asset_select_options(assigns.site)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:assets, assets)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"route" => route_params}, socket) do
    changeset =
      socket.assigns.route
      |> Hosting.change_route(route_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"route" => route_params}, socket) do
    save_route(socket, socket.assigns.action, route_params)
  end

  defp save_route(socket, :edit, route_params) do
    case Hosting.update_route(socket.assigns.route, route_params) do
      {:ok, _route} ->
        {:noreply,
         socket
         |> put_flash(:info, "Site route updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_route(socket, :new, route_params) do
    case Hosting.create_route(socket.assigns.site, route_params) do
      {:ok, _route} ->
        {:noreply,
         socket
         |> put_flash(:info, "Site route created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
