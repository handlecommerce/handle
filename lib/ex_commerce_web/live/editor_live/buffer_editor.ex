defmodule ExCommerceWeb.EditorLive.BufferEditor do
  use Phoenix.Component

  alias ExCommerce.Editor.Buffer

  def editor(assigns) do
    ~H"""
    <div id="editor-1" phx-hook="MonacoEditor" class="w-full flex-grow" phx-update="ignore"></div>
    """
  end
end
