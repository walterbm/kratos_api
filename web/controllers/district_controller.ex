defmodule KratosApi.DistrictController do
  use KratosApi.Web, :controller

  #plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  def show(conn, params) do
    query = from p in KratosApi.Person,
      join: r in KratosApi.Role,
      where: r.person_id == p.id,
      where: r.state == ^String.upcase(params["state"]),
      where: r.district == ^params["id"] or r.role_type ==  "senator",
      preload: [:roles]


    {representatives, kerosene} = query |> KratosApi.Repo.paginate(params)

    render(conn, "representatives.json", representatives: representatives, kerosene: kerosene)
  end

end
