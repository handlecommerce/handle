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
    <aside class="w-64 sticky bg-gray-800 shadow flex-col justify-between flex h-screen top-0 text-gray-400 py-4 px-2">
      <ul>
        <%= for node <- @tree do %>
          <.tree_node node={node} myself={@myself} />
        <% end %>
      </ul>
    </aside>
    """
  end

  def handle_event("toggle-expansion", %{"node-id" => node_id}, socket) do
    socket = assign(socket, :tree, toggle_node(socket.assigns.tree, node_id))
    {:noreply, socket}
  end

  attr :node, :any, required: true
  attr :myself, :any, required: true

  # Render a file node
  defp tree_node(%{node: %{type: :file}} = assigns) do
    # Clicking on this node will cause a new tab to be opened

    ~H"""
    <li class="my-2">
      <span
        class="flex leading-5 hover:text-gray-200 hover:cursor-pointer"
        phx-click="load-file"
        phx-value-id={@node.id}
      >
        <Heroicons.document class="h-4 w-4 mr-1" /> <%= @node.name %>
      </span>
    </li>
    """
  end

  defp tree_node(%{node: node} = assigns) do
    # Clicking on this node will cause the collapse or expansion of the node
    assigns = assign(assigns, :rotation, if(node.expanded, do: "rotate-90", else: ""))

    ~H"""
    <li class="my-2">
      <span
        class="flex leading-4 hover:text-gray-200 hover:cursor-pointer"
        phx-click="toggle-expansion"
        phx-target={@myself}
        phx-value-node-id={@node.id}
      >
        <Heroicons.chevron_right class={["h-4 w-4 mr-1 transition-all", @rotation]} />
        <%= @node.name %>
      </span>

      <%= if @node.expanded do %>
        <ul class="pl-4">
          <%= for child <- @node.children do %>
            <.tree_node node={child} myself={@myself} />
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
