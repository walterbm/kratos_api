defmodule KratosApi.CongressController do
  use KratosApi.Web, :controller

  alias KratosApi.{
    Repo,
    FloorActivity
  }

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  def recess(conn, _params) do
    query = from r in KratosApi.CongressionalRecess,
      where: r.start_date <= ^Ecto.Date.utc and r.end_date >= ^Ecto.Date.utc

    recess? = case Repo.all(query) do
      [] -> false
      _  -> true
    end

    json conn, %{"recess": recess?}
  end

  def floor(conn, %{"chamber" => chamber}) do
    render conn, "activities.json", activities: FloorActivity.active(chamber)
  end

end
