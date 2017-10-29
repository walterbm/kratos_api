defmodule KratosApi.CongressController do
  use KratosApi.Web, :controller

  alias KratosApi.{
    Bill,
    Repo,
    BillView,
  }

  # plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  def recess(conn, _params) do
    senate = from r in KratosApi.CongressionalRecess,
      where: r.start_date <= ^Ecto.Date.utc
      and r.end_date >= ^Ecto.Date.utc
      and r.chamber == "senate"

    house = from r in KratosApi.CongressionalRecess,
      where: r.start_date <= ^Ecto.Date.utc
      and r.end_date >= ^Ecto.Date.utc
      and r.chamber == "house"

    senate_recess? = exists?(senate)
    house_recess? = exists?(house)

    json conn, %{
      "senate": senate_recess?,
      "house": house_recess?,
      "recess": senate_recess? || house_recess?
    }
  end

  def floor(conn, %{"chamber" => chamber}) do
    render conn, BillView, "bills.json", bills: Bill.active_in(chamber)
  end

  def trending(conn, _params) do
    render conn, BillView, "bills.json", bills: Bill.trending
  end

  defp exists?(query) do
    case Repo.all(query) do
      [] -> false
      _  -> true
    end
  end

end
