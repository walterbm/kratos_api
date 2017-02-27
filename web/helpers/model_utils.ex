defmodule KratosApi.Model.Utils do

  def append_current(assoc, current, new, unique_by) do
    new =
      Map.get(new, assoc, [])
      |> Enum.map(&(&1.data))

    current =
      Map.get(current, assoc, [])

    collection = current ++ new

    collection
    |> Enum.uniq_by(fn x -> Map.get(x, unique_by) end)
    |> Enum.reject(&is_nil/1)
  end


end
