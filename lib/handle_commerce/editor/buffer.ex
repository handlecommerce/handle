defmodule HandleCommerce.Editor.Buffer do
  defstruct [:id, :asset]

  alias HandleCommerce.Resources.Asset

  @type t :: %__MODULE__{
          id: String.t(),
          asset: Asset.t()
        }

  @spec new(Asset.t()) :: t()
  def new(%Asset{} = asset) do
    %__MODULE__{
      id: to_string(asset.id),
      asset: asset
    }
  end

  @spec title(t()) :: String.t()
  def title(%__MODULE__{asset: %{key: key}}), do: Path.basename(key)
end
