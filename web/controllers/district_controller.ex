defmodule KratosApi.DistrictController do
  use KratosApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  def show(conn, %{"state" => state, "id" => id}) do

    query = from r in KratosApi.Role,
      where: r.state == ^String.upcase(state),
      where: r.district == ^id or r.role_type ==  "senator",
      preload: [:person, :congress_numbers]

    representatives = KratosApi.Repo.all(query)
    render conn, "roles.json", roles: representatives
  end

end
