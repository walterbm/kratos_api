defmodule KratosApi.DistrictController do
  use KratosApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  def show(conn, params) do
    query = from p in KratosApi.Person,
      join: t in KratosApi.Term,
      where: t.person_id == p.id,
      where: p.current_state == ^String.upcase(params["state"]),
      where: p.current_district == ^params["id"] or p.current_office ==  "Senate",
      preload: [:terms]


    {representatives, kerosene} = query |> KratosApi.Repo.paginate(params)

    render(conn, "representatives.json", representatives: representatives, kerosene: kerosene)
  end

end
