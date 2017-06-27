defmodule KratosApi.RecessController do
  use KratosApi.Web, :controller

  alias KratosApi.{
    Repo,
    FloorActivity
  }

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  def recess(conn, _params) do
    query = from r in KratosApi.CongressionalRecess,
      where: r.start_date <= ^Ecto.Date.utc,
      where: r.end_date >= ^Ecto.Date.utc

    recess? = case Repo.all(query) do
      [] -> false
      _  -> true
    end

    json conn, %{"recess": recess?}
  end

  def activity(conn, %{"chamber" => chamber}) do
    query =
      from activity in FloorActivity,
      where: activity.chamber == ^chamber,
      order_by: [desc: activity.published_at]

    render conn, "activity.json", activity: Repo.all(query)
  end

end
