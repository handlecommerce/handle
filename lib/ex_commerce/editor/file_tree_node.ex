defmodule ExCommerce.Editor.FileTreeNode do
  @enforce_keys [:id, :type, :name]
  defstruct [:id, :type, :name, :expanded, :children]

  alias ExCommerce.Resources.Asset

  @type t :: %__MODULE__{
          id: integer,
          type: :directory | :file,
          name: String.t(),
          expanded: boolean() | nil,
          children: list(t) | nil
        }

  def new(path, acc \\ [])

  def new(%Asset{key: key}, acc) do
    key
    |> String.split("/")
    |> Enum.reject(&(&1 == ""))
    |> new(acc)
  end

  def new([filename | []], acc) do
    record = %__MODULE__{
      id: unique_id(),
      type: :file,
      name: filename
    }

    case Enum.find_index(acc, &(&1.name == filename)) do
      nil -> [record | acc] |> Enum.sort_by(& &1.name)
      i -> List.update_at(acc, i, fn _old -> record end)
    end
  end

  def new([directory_name | children], acc) do
    case Enum.find_index(acc, &(&1.name == directory_name)) do
      nil ->
        [
          %__MODULE__{
            id: unique_id(),
            type: :directory,
            name: directory_name,
            expanded: false,
            children: new(children)
          }
          | acc
        ]

      i ->
        List.update_at(acc, i, fn record ->
          %{record | children: new(children, record.children)}
        end)
    end
  end

  defp unique_id, do: to_string(System.unique_integer())
end
