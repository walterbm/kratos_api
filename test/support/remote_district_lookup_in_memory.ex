defmodule KratosApi.FindDistrict.InMemory do

  def by_address(_) do
    {:ok, %{
      "district" => 28,
      "state" => "TX",
      "city" => "San Antonio",
      "zip" => 78219,
    }}
  end

  def by_query(_) do
    {:ok, [%{state: "CA", district: 12}]}
  end

end
