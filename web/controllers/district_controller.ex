defmodule KratosApi.DistrictController do
  use KratosApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  def show(conn, %{"state" => state, "id" => id}) do
    representatives =
      Govtrack.roles([current: true, state: state]).body["objects"]
      |> Enum.filter(fn(x) -> x["district"] == String.to_integer(id) || x["role_type"] == "senator" end)
      |> Enum.map( fn(x) -> Map.put(x, "image","#{Application.get_env(:kratos_api, :assets_url)}/225x275/#{x["person"]["bioguideid"]}.jpg") end)
    json conn, representatives
  end

end
