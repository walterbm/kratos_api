defmodule KratosApi.FindDistrict do

  @geocodio Application.get_env(:kratos_api, :geocodio)

  def by_address(%{"address" => address, "city" => city, "state" => state, "zip" => zip}) do
    geocodio_response =
      HTTPotion.get(@geocodio[:api_url], query: %{q: "#{address} #{city} #{state} #{zip}", api_key: @geocodio[:api_key], fields: "cd"}).body
      |> Poison.decode!

    %{"district" => List.first(geocodio_response["results"])["fields"]["congressional_district"]["district_number"]}
  end

  def by_address(_), do: %{}

end
