defmodule KratosApi.DistrictController do
  use KratosApi.Web, :controller

  require IEx

  plug :scrub_params, "address" when action in [:post]

  def post(conn, params) do
    response = HTTPotion.get Application.get_env(:kratos_api, :geocodio)[:api_url],
      query: %{
        q: params["address"],
        api_key: Application.get_env(:kratos_api, :geocodio)[:api_key],
        fields: "cd"
      }
    json conn, Poison.decode! response.body
  end

end
