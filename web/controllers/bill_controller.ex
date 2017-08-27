defmodule KratosApi.BillController do
  use KratosApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  alias KratosApi.{
    Bill,
    Repo,
  }

  def index(conn, params) do
    { bills, kerosene } = Bill.query_all(params) |> Repo.paginate(params)
    render(conn, "bills.json", bills: bills, kerosene: kerosene)
  end

  def show(conn, %{"id" => id}) do
    bill =
      Repo.get!(Bill, id)
      |> Repo.preload([:top_subject, :subjects, :sponsor, :cosponsors, :committees, :related_bills, :tallies])
      |> Repo.preload(sponsor: :terms)
      |> Repo.preload(cosponsors: :terms)
      |> Repo.preload(tallies: [:votes, votes: :person])
    render conn, "bill.json", bill: bill
  end

  def sponsored(conn, params) do
    {bills, kerosene} = Bill.query_sponsored(params) |> Repo.paginate(params)

    render(conn, "bills.json", bills: bills, kerosene: kerosene)
  end

end
