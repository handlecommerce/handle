defmodule ExCommerceWeb.EditorLive.Index do
  use ExCommerceWeb, :live_editor

  alias ExCommerce.Resources
  alias ExCommerce.Editor.Buffer
  alias ExCommerce.Hosting
  alias ExCommerceWeb.EditorLive.{FileExplorer, FileTabs, BufferEditor}

  @impl true
  def mount(params, _session, socket) do
    site = Hosting.get_site!(params["site_id"])

    {:ok,
     socket
     |> assign(:site, site)
     |> assign(:buffers, [])
     |> assign(:focused_buffer, nil)
     |> assign(:live_preview_content, nil)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex">
      <.live_component module={FileExplorer} id="file-explorer" site={@site} />
      <div class="flex flex-col flex-grow">
        <FileTabs.tabs buffers={@buffers} focused_buffer={@focused_buffer} />
        <%= if @focused_buffer do %>
          <BufferEditor.editor />
        <% end %>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("load-file", %{"id" => id}, socket) do
    if Enum.any?(socket.assigns.buffers, &(&1.id == id)) do
      # File already loaded? Focus that buffer instead
      {:noreply, focus_buffer(socket, id)}
    else
      {:noreply, load_new_buffer(socket, id)}
    end
  end

  def handle_event("focus-buffer", %{"id" => id}, socket),
    do: {:noreply, focus_buffer(socket, id)}

  def handle_event("close-file", %{"id" => id}, socket) do
    index = Enum.find_index(socket.assigns.buffers, &(&1.id == id))

    socket =
      socket
      |> assign(:buffers, List.delete_at(socket.assigns.buffers, index))
      |> push_event("close-buffer", %{id: id})

    {:noreply, focus_buffer(socket, index - 1)}
  end

  def handle_event("save-buffer", %{"id" => id, "content" => content}, socket) do
    socket.assigns.site
    |> Resources.get_asset!(id)
    |> Resources.update_text_asset(%{content: content})
    |> IO.inspect()

    {:noreply, socket}
  end

  def handle_event("generate-preview", %{"content" => content}, socket) do
    with {:ok, document} <- Liquex.parse(content),
         {result, _} <- Liquex.render(document, %{}) do
      {:noreply, socket |> push_event("display-preview", %{content: result})}
    else
      _ -> {:noreply, socket}
    end
  end

  defp focus_buffer(socket, id) when is_binary(id) do
    case Enum.find(socket.assigns.buffers, &(&1.id == id)) do
      # Buffer not found. This is an error state
      nil ->
        socket

      buffer ->
        socket
        |> push_event("focus-buffer", %{id: id})
        |> assign(:focused_buffer, buffer)
    end
  end

  defp focus_buffer(socket, index) when is_integer(index) do
    case Enum.at(socket.assigns.buffers, index, List.first(socket.assigns.buffers)) do
      nil ->
        assign(socket, :focused_buffer, nil)

      buffer ->
        socket
        |> push_event("focus-buffer", %{id: buffer.id})
        |> assign(:focused_buffer, buffer)
    end
  end

  defp load_new_buffer(socket, id) do
    asset = Resources.get_asset!(socket.assigns.site, id)
    buffer = Buffer.new(asset)

    loaded_buffers = [buffer | Enum.reverse(socket.assigns.buffers)] |> Enum.reverse()

    socket
    |> assign(:focused_buffer, buffer)
    |> assign(:buffers, loaded_buffers)
    |> push_event("load-buffer", %{id: id, content: asset.content, language: "html"})
  end
end
