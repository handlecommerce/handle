defmodule ExCommerceWeb.EditorLive.FileTabs do
  use Phoenix.Component

  alias ExCommerce.Editor.OpenAsset

  attr :assets, :any, required: true

  def tabs(assigns) do
    ~H"""
    <ul class="flex flex-wrap border-b border-gray-200">
      <%= for asset <- @assets do %>
        <.tab asset={asset} />
      <% end %>
    </ul>
    """
  end

  attr :asset, :any, required: true
  attr :active, :boolean, default: false
  attr :disabled, :boolean, default: false

  defp tab(%{active: active} = assigns) do
    classes =
      if active,
        do: ["bg-gray-100 text-blue-600 border-b-gray-200"],
        else: [
          "text-gray-500 hover:text-gray-600 hover:bg-gray-50 border-b-white hover:border-b-gray-200"
        ]

    assigns = assign(assigns, :classes, classes)

    ~H"""
    <li>
      <a
        href="#"
        class={[
          "rounded-t-md py-1 pl-4 pr-2 text-sm font-medium text-center border-b-2 flex" | @classes
        ]}
      >
        <%= OpenAsset.title(@asset) %>
        <.close_icon asset_id={@asset.asset.id} />
      </a>
    </li>
    """
  end

  def close_icon(assigns) do
    ~H"""
    <Heroicons.x_mark
      class={[
        "h-3 w-3 ml-3 mt-1.5 hover:bg-gray-200 rounded-sm hover:text-cyan-800 text-center"
      ]}
      phx-click="close-file"
      phx-value-id={@asset_id}
    />
    """
  end
end
