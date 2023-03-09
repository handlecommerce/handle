defmodule ExCommerceWeb.EditorLive.BufferEditor do
  use Phoenix.Component

  def editor(assigns) do
    ~H"""
    <div phx-update="ignore" id="monaco-editor-wrapper" class="flex flex-grow flex-row">
      <div id="monaco-editor" phx-hook="MonacoEditor" class="w-full flex-1"></div>
      <live-preview class="flex-1">Some Content</live-preview>
    </div>
    """
  end
end
