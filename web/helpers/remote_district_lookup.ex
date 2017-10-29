defmodule KratosApi.FindDistrict do

  @geocodio Application.get_env(:kratos_api, :geocodio)

  def by_query(query) do
    districts = all(query)

    case districts do
      [] -> {:error, "No results found"}
      _  -> {:ok, districts}
    end
  end

  def by_address(%{"address" => address, "city" => city, "state" => state, "zip" => zip}) do
    geocodio_response = first("#{address} #{city} #{state} #{zip}")

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

  defp first(query) do
    query
    |> search
    |> List.first
    |> handle_district_of_columbia
  end

  defp all(query) do
    query
    |> search
    |> Enum.map(fn result ->
      if found_district?(result) do
        %{
          district: result["fields"]["congressional_district"]["district_number"],
          state: result["address_components"]["state"]
        }
      end
    end)
    |> Enum.uniq
    |> Enum.reject(&is_nil/1)
  end

  defp search(query) do
    HTTPotion.get(@geocodio[:api_url], query: %{q: query, api_key: @geocodio[:api_key], fields: "cd"}).body
    |> Poison.decode!
    |> Map.get("results", [])
  end

  defp handle_district_of_columbia(response = %{"address_components" => %{"county" => "District of Columbia" }}) do
    %{response | "fields" => %{"congressional_district" => %{"district_number" => 0}}}
  end
  defp handle_district_of_columbia(response), do: response

  defp found_district?(response) do
    !!get_in(response, ["fields", "congressional_district", "district_number"])
  end

end
