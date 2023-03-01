defmodule ExCommerce.Editor.FileTreeNode do
  @enforce_keys [:id, :type, :name]
  defstruct [:id, :type, :name, :key, :expanded, :children]

  alias ExCommerce.Resources.Asset

  @type t :: %__MODULE__{
          id: String.t(),
          type: :directory | :file,
          name: String.t(),
          key: String.t() | nil,
          expanded: boolean() | nil,
          children: list(t) | nil
        }

  def new(%Asset{id: id, key: key}, acc) do
    key
    |> String.split("/")
    |> Enum.reject(&(&1 == ""))
    |> create_node(id, acc)
  end

  defp create_node(path, asset_id, acc \\ [])

  defp create_node([filename | []], asset_id, acc) do
    # Found a filename. Create a file node
    record = %__MODULE__{
      id: to_string(asset_id),
      type: :file,
      name: filename
    }

    case Enum.find_index(acc, &(&1.name == filename)) do
      nil -> Enum.sort_by([record | acc], & &1.name)
      i -> List.update_at(acc, i, fn _old -> record end)
    end
  end

  defp create_node([directory_name | children], asset_id, acc) do
    # Found a directory. Create a directory node
    case Enum.find_index(acc, &(&1.name == directory_name)) do
      nil ->
        # Create a new directory since this one wasn't found
        [
          %__MODULE__{
            id: Ecto.UUID.generate(),
            type: :directory,
            name: directory_name,
            expanded: false,
            children: create_node(children, asset_id)
          }
          | acc
        ]

      i ->
        # This directory exists. Append the node as a child to it
        List.update_at(acc, i, fn record ->
          %{record | children: create_node(children, asset_id, record.children)}
        end)
    end
  end
end
