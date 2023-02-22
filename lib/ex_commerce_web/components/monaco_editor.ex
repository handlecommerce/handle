defmodule ExCommerceWeb.MonacoEditor do
  use Phoenix.Component

  import ExCommerceWeb.CoreComponents

  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil

  attr :field, :any, doc: "a %Phoenix.HTML.Form{}/field name tuple, for example: {f, :contents}"

  @spec editor(map) :: Phoenix.LiveView.Rendered.t()
  def editor(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign_new(:name, fn -> field.name end)
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign_new(:value, fn -> field.value end)
    |> do_editor()
  end

  defp do_editor(assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <.label for={@id}><%= @label %></.label>
      <div
        id="editor-1"
        phx-hook="MonacoEditor"
        class="w-full h-96 border-2"
        phx-update="ignore"
        data-editor-field={@id}
        data-editor-value={@value}
      >
      </div>
      <input type="hidden" name={@name} id={@id || @name} value={@value} />
    </div>
    """
  end
end
