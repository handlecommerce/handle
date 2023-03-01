defmodule ExCommerceWeb.EditorLive.Editor do
  use ExCommerceWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id="editor-1" phx-hook="MonacoEditor" class="w-full flex-grow" phx-update="ignore"></div>
    """
  end

  def update(%{asset: asset} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:asset, asset)
     |> set_contents(asset)}
  end

  defp set_contents(socket, nil), do: socket

  defp set_contents(socket, %{asset: %{content: content}}),
    do: push_event(socket, "load-contents", %{contents: content})
end
