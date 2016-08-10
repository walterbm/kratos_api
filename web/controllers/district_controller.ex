defmodule KratosApi.DistrictController do
  use KratosApi.Web, :controller

  plug :scrub_params, "address" when action in [:post]

  def post(conn, %{"address" => address}) do
    [{_, api_key},{_, api_url}] = Application.get_env(:kratos_api, :geocodio)
    response = HTTPotion.get api_url,
      query: %{q: address, api_key: api_key, fields: "cd"}

    json conn, Poison.decode! response.body
  end

  def show(conn, %{"state" => state, "id" => id}) do
    representatives =
      Govtrack.roles([current: true, state: state]).body["objects"]
      |> Enum.filter(fn(x) -> x["district"] == String.to_integer(id) || x["role_type"] == "senator" end)
      |> Enum.map( fn(x) -> Map.put(x, "image","#{Application.get_env(:kratos_api, :assets_url)}/225x275/#{x["person"]["bioguideid"]}.jpg") end)
    json conn, representatives
  end

end
