defmodule KratosApi.BillController do
  use KratosApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  def show(conn, %{"id" => id}) do
    bill =
      KratosApi.Repo.get!(KratosApi.Bill, id)
      |> KratosApi.Repo.preload([:subjects, :sponsor, :cosponsors, :committees, :related_bills, :tallies])
      |> KratosApi.Repo.preload(sponsor: :terms)
      |> KratosApi.Repo.preload(cosponsors: :terms)
      |> KratosApi.Repo.preload(tallies: [:votes, votes: :person])
    render conn, "bill.json", bill: bill
  end

  def sponsored(conn, params) do
    query = from b in KratosApi.Bill,
      where: b.sponsor_id == ^params["id"]

    {bills, kerosene} = query |> KratosApi.Repo.paginate(params)

    render(conn, "bills.json", bills: bills, kerosene: kerosene)
  end

end
