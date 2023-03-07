defmodule ExCommerceWeb.EditorLive.BufferEditor do
  use Phoenix.Component

  def editor(assigns) do
    ~H"""
    <div phx-update="ignore" id="monaco-editor-wrapper" class="flex flex-grow">
      <div id="monaco-editor" phx-hook="MonacoEditor" class="w-full flex-grow"></div>
    </div>
    """
  end
end
