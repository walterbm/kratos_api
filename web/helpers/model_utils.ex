defmodule KratosApi.Model.Utils do

  def append_current(assoc, old, new, unique_key) do
    new =
      Map.get(new, assoc, [])
      |> Enum.map(&(&1.data))

    old =
      Map.get(old, assoc, [])

    compare_and_merge(new, old, unique_key)
  end

  defp compare_and_merge(new, old, unique_key) do
    if (Enum.count(new) == Enum.count(old)) do
      new
    else
      new
      |> Kernel.++(old)
      |> Enum.uniq_by(&(Map.get(&1, unique_key)))
    end
  end

end
