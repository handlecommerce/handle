defmodule ExCommerceWeb.MonacoEditor do
  use Phoenix.Component

  import ExCommerceWeb.CoreComponents

  attr :id, :any
  attr :name, :any
  attr :label, :string, default: nil

  attr :field, :any, doc: "a %Phoenix.HTML.Form{}/field name tuple, for example: {f, :email}"

  @spec editor(map) :: Phoenix.LiveView.Rendered.t()
  def editor(%{field: {f, field}} = assigns) do
    assigns
    |> assign_new(:name, fn -> Phoenix.HTML.Form.input_name(f, field) end)
    |> assign_new(:id, fn -> Phoenix.HTML.Form.input_id(f, field) end)
    |> assign_new(:value, fn -> Phoenix.HTML.Form.input_value(f, field) end)
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
