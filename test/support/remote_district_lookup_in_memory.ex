defmodule KratosApi.FindDistrict.InMemory do

  def by_address(_) do
    %{
      "district" => 28,
      "state" => "TX",
      "city" => "San Antonio",
      "zip" => 78219,
    }
  end

end
