defmodule KratosApi.Model.Utils do

  def append_current(assoc, current, new) do
    new =
      Map.get(new, assoc, [])
      |> Enum.map(&(&1.data))

    Map.get(current, assoc, [])
    |> Kernel.++(new)
    |> Enum.reject(&is_nil/1)
  end
  
end
