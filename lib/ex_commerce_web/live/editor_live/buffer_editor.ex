defmodule ExCommerceWeb.EditorLive.BufferEditor do
  use Phoenix.Component

  def editor(assigns) do
    ~H"""
    <div phx-update="ignore" id="monaco-editor-wrapper" class="flex flex-grow flex-row">
      <div id="monaco-editor" phx-hook="MonacoEditor" class="w-full flex-1"></div>
      <div class="flex-1" id="live-preview">Live Preview</div>
    </div>
    """
  end
end
