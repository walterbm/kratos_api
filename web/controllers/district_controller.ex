defmodule KratosApi.DistrictController do
  use KratosApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  def show(conn, %{"state" => state, "id" => id}) do
    representatives =
      Govtrack.roles([current: true, state: state]).body["objects"]
      |> Enum.filter(&(&1["district"] == String.to_integer(id) || &1["role_type"] == "senator"))
      |> Enum.map(&(Map.put(&1, "image","#{Application.get_env(:kratos_api, :assets_url)}/225x275/#{&1["person"]["bioguideid"]}.jpg")))
    json conn, representatives
  end

end
