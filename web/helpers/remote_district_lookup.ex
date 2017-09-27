defmodule KratosApi.FindDistrict do

  @geocodio Application.get_env(:kratos_api, :geocodio)

  def by_address(%{"address" => address, "city" => city, "state" => state, "zip" => zip}) do
    geocodio_response =
      HTTPotion.get(@geocodio[:api_url], query: %{q: "#{address} #{city} #{state} #{zip}", api_key: @geocodio[:api_key], fields: "cd"}).body
      |> Poison.decode!
      |> Map.get("results")
      |> List.first

    if geocodio_response["fields"]["congressional_district"]["district_number"] do
      {:ok, address_fields_map(geocodio_response)}
    else
      {:error, geocodio_response}
    end
  end
  def by_address(_), do: %{}

  defp address_fields_map(geocodio_response) do
    %{
      "district" => geocodio_response["fields"]["congressional_district"]["district_number"],
      "state" => geocodio_response["address_components"]["state"],
      "city" => geocodio_response["address_components"]["city"],
      "zip" => geocodio_response["address_components"]["zip"],
    }
  end

end
