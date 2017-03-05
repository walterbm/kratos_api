defmodule KratosApi.RecessController do
  use KratosApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  def index(conn, _params) do
    query = from r in KratosApi.CongressionalRecess,
      where: r.start_date <= ^Ecto.Date.utc,
      where: r.end_date >= ^Ecto.Date.utc

    response = case Repo.all(query) do
      [] -> %{"recess": false}
      _  -> %{"recess": true}
    end

    json conn, response
  end

end
