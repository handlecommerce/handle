defmodule HandleCommerce.TestHelpers do
  def records_equal?(struct1, struct2)
      when is_list(struct1) and is_list(struct2) do
    struct1
    |> Enum.zip(struct2)
    |> Enum.all?(fn {l, r} -> records_equal?(l, r) end)
  end

  def records_equal?(struct1, struct2) do
    # get the list of keys for the first struct
    keys = struct1.__struct__.__schema__(:fields)

    # iterate over the keys and check if the values are equal
    Enum.all?(keys, fn key ->
      %{^key => value1} = struct1
      %{^key => value2} = struct2

      case {value1, value2} do
        {Ecto.Association.NotLoaded, _} -> true
        {_, Ecto.Association.NotLoaded} -> true
        {val1, val2} -> val1 == val2
      end
    end)
  end
end
