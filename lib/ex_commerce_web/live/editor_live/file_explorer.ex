defmodule ExCommerceWeb.EditorLive.FileExplorer do
  use ExCommerceWeb, :live_component

  alias ExCommerce.Hosting.Site
  alias ExCommerce.Resources
  alias ExCommerce.Editor.FileTreeNode

  def update(%{site: site} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:assets, load_assets(site))}
  end

  def render(assigns) do
    ~H"""
    <ul>
      <%= for node <- @assets do %>
        <.render_node node={node} />
      <% end %>
    </ul>
    """
  end

  attr :node, :any, required: true

  defp render_node(%{node: %{type: :file}} = assigns) do
    ~H"""
    <li class="my-2">
      <span class="flex leading-5">
        <Heroicons.document class="h-4 w-4 mr-1" /> <%= @node.name %>
      </span>
    </li>
    """
  end

  defp render_node(assigns) do
    ~H"""
    <li class="my-2">
      <span class="flex leading-4">
        <Heroicons.chevron_down class="h-4 w-4 mr-1" /> <%= @node.name %>
      </span>
      <ul class="pl-4">
        <%= for child <- @node.children do %>
          <.render_node node={child} />
        <% end %>
      </ul>
    </li>
    """
  end

  defp load_assets(%Site{} = site) do
    site
    |> Resources.list_assets()
    |> Enum.reduce([], &FileTreeNode.new/2)
  end
end
