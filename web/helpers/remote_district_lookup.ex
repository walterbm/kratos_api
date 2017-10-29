defmodule KratosApi.FindDistrict do

  @geocodio Application.get_env(:kratos_api, :geocodio)

  def by_query(query) do
    geocodio_response = search(query)

    if found_district?(geocodio_response) do
      district = geocodio_response["fields"]["congressional_district"]["district_number"]
      state = geocodio_response["address_components"]["state"]
      {:ok, {state, district}}
    else
      {:error, geocodio_response}
    end
  end

  def by_address(%{"address" => address, "city" => city, "state" => state, "zip" => zip}) do
    geocodio_response = search("#{address} #{city} #{state} #{zip}")

    if found_district?(geocodio_response) do
      {:ok, address_fields_map(geocodio_response)}
    else
      {:error, geocodio_response}
    end
  end
  def by_address(_), do: {:ok, %{}}

  defp address_fields_map(geocodio_response) do
    %{
      "district" => geocodio_response["fields"]["congressional_district"]["district_number"],
      "state" => geocodio_response["address_components"]["state"],
      "city" => geocodio_response["address_components"]["city"],
      "zip" => geocodio_response["address_components"]["zip"],
    }
  end

  defp search(query) do
    HTTPotion.get(@geocodio[:api_url], query: %{q: query, api_key: @geocodio[:api_key], fields: "cd"}).body
    |> Poison.decode!
    |> Map.get("results")
    |> List.first
    |> handle_district_of_columbia
  end

  defp handle_district_of_columbia(response = %{"address_components" => %{"county" => "District of Columbia" }}) do
    %{response | "fields" => %{"congressional_district" => %{"district_number" => 0}}}
  end
  defp handle_district_of_columbia(response), do: response

  defp found_district?(response) do
    !!get_in(response, ["fields", "congressional_district", "district_number"])
  end

end
