defmodule ExCommerceWeb.EditorLive.BufferEditor do
  use ExCommerceWeb, :live_component

  def mount(socket) do
    {:ok, assign(socket, :preview_content, nil)}
  end

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_preview_content("")}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-grow">
      <div phx-update="ignore" id="monaco-editor-wrapper" class="w-1/2 flex ">
        <div id="monaco-editor" phx-hook="MonacoEditor" class="w-full"></div>
      </div>
      <div
        id="editor-gutter"
        class="bg-gray-200 cursor-ew-resize flex justify-center items-center"
        phx-hook="DraggableGutter"
      >
        <Heroicons.ellipsis_vertical class="w-4" />
      </div>

      <iframe srcdoc={@preview_content} class="flex-grow"></iframe>

      <.error_message error={@error} error_line={@error_line} />
    </div>
    """
  end

  attr(:error, :string, required: false)
  attr(:error_line, :integer, required: false)

  defp error_message(assigns) do
    ~H"""
    <%= if @error do %>
      <div
        class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded fixed bottom-1 right-1"
        role="alert"
      >
        <strong class="font-bold">Error!</strong>
        <span class="block sm:inline">
          <%= @error %>

          <%= if @error_line do %>
            at line #<%= @error_line %>
          <% end %>
        </span>
      </div>
    <% end %>
    """
  end

  def handle_event("generate-preview", %{"content" => content}, socket) do
    {:noreply, assign_preview_content(socket, content)}
  end

  defp assign_preview_content(socket, content) do
    try do
      with {:ok, document} <- Liquex.parse(content || ""),
           {result, _} <- Liquex.render!(document, %{}) do
        socket
        |> assign(:preview_content, to_string(result))
        |> assign(:error, nil)
        |> assign(:error_line, nil)
        |> push_event("clear-highlight", %{})
      else
        {:error, message, line} ->
          socket
          |> assign(:error, message)
          |> assign(:error_line, line)
          |> push_event("highlight", %{type: "severe", line: line, message: message})
      end
    rescue
      e in Liquex.Error ->
        socket
        |> assign(:error, e.message)
        |> assign(:error_line, nil)
        |> push_event("clear-highlight", %{})

      e ->
        socket
        |> assign(:error, Exception.message(e))
        |> assign(:error_line, nil)
        |> push_event("clear-highlight", %{})
    end
  end
end
