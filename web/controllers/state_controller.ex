defmodule KratosApi.StateController do
  use KratosApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  def show(conn, %{ "state" => state }) do
    query = from p in KratosApi.Person,
      where: p.is_current == true,
      where: p.current_state == ^String.upcase(state),
      distinct: p.current_district,
      where: not is_nil(p.current_district),
      select: p.current_district

    districts = KratosApi.Repo.all(query)

    json conn, %{ districts: districts }
  end

end
