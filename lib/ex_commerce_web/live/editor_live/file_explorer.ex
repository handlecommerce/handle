defmodule ExCommerceWeb.EditorLive.FileExplorer do
  use ExCommerceWeb, :live_component

  alias ExCommerce.Hosting.Site
  alias ExCommerce.Resources
  alias ExCommerce.Editor.FileTreeNode

  def update(%{site: site} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:tree, load_asset_tree(site))}
  end

  def render(assigns) do
    ~H"""
    <ul>
      <%= for node <- @tree do %>
        <.render_node node={node} myself={@myself} />
      <% end %>
    </ul>
    """
  end

  def handle_event("toggle-expansion", %{"node-id" => node_id}, socket) do
    socket = assign(socket, :tree, toggle_node(socket.assigns.tree, node_id))
    {:noreply, socket}
  end

  attr :node, :any, required: true
  attr :myself, :any, required: true

  # Render a file node
  defp render_node(%{node: %{type: :file}} = assigns) do
    # Clicking on this node will cause a new tab to be opened

    ~H"""
    <li class="my-2">
      <span class="flex leading-5">
        <Heroicons.document class="h-4 w-4 mr-1" /> <%= @node.name %>
      </span>
    </li>
    """
  end

  defp render_node(%{node: node} = assigns) do
    # Clicking on this node will cause the collapse or expansion of the node
    assigns = assign(assigns, :rotation, if(node.expanded, do: "rotate-90", else: ""))

    ~H"""
    <li class="my-2">
      <span
        class="flex leading-4"
        phx-click="toggle-expansion"
        phx-target={@myself}
        phx-value-node-id={@node.id}
      >
        <Heroicons.chevron_right class="h-4 w-4 mr-1 {@rotation}" />
        <%= @node.name %>
      </span>

      <%= if @node.expanded do %>
        <ul class="pl-4">
          <%= for child <- @node.children do %>
            <.render_node node={child} myself={@myself} />
          <% end %>
        </ul>
      <% end %>
    </li>
    """
  end

  defp load_asset_tree(%Site{} = site) do
    site
    |> Resources.list_assets()
    |> Enum.reduce([], &FileTreeNode.new/2)
  end

  defp toggle_node(nil, _), do: nil

  defp toggle_node(nodes, node_id) do
    case Enum.find_index(nodes, &(&1.id == node_id)) do
      nil ->
        Enum.map(nodes, &%{&1 | children: toggle_node(&1.children, node_id)})

      idx ->
        node = Enum.at(nodes, idx)
        List.replace_at(nodes, idx, %{node | expanded: !node.expanded})
    end
  end
end
