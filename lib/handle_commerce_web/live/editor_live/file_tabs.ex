defmodule HandleCommerceWeb.EditorLive.FileTabs do
  use Phoenix.Component

  alias HandleCommerce.Editor.Buffer

  attr(:buffers, :any, required: true)
  attr(:focused_buffer, :any, required: true)

  def tabs(assigns) do
    ~H"""
    <span class="flex flex-wrap border-b border-gray-200">
      <%= for buffer <- @buffers do %>
        <.tab buffer={buffer} active={buffer == @focused_buffer} />
      <% end %>
    </span>
    """
  end

  attr(:buffer, :any, required: true)
  attr(:active, :boolean, default: false)

  defp tab(assigns) do
    ~H"""
    <label class="select-none text-sm font-medium text-center">
      <input
        type="radio"
        name="file-tabs"
        class="hidden peer"
        checked={@active}
        phx-click="focus-buffer"
        phx-value-id={@buffer.id}
      />
      <span class="rounded-t-md py-1 pl-4 pr-2 border-b-2 flex cursor-pointer peer-checked:bg-gray-200 peer-checked:text-blue-800 peer-checked:border-b-gray-200">
        <%= Buffer.title(@buffer) %>
        <.close_icon buffer_id={@buffer.id} />
      </span>
    </label>
    """
  end

  def close_icon(assigns) do
    ~H"""
    <Heroicons.x_mark
      class={[
        "h-3 w-3 ml-3 mt-1.5 hover:bg-gray-200 rounded-sm hover:text-cyan-800 text-center"
      ]}
      phx-click="close-file"
      phx-value-id={@buffer_id}
    />
    """
  end
end
