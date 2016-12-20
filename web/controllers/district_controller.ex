defmodule KratosApi.DistrictController do
  use KratosApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  def show(conn, params) do
    query = from r in KratosApi.Role,
      where: r.state == ^String.upcase(params["state"]),
      where: r.district == ^params["id"] or r.role_type ==  "senator",
      preload: [:person, :congress_numbers]

    {representatives, kerosene} = query |> KratosApi.Repo.paginate(params)

    render(conn, "roles.json", roles: representatives, kerosene: kerosene)
  end

end
