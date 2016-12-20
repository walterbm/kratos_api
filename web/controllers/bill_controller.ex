defmodule KratosApi.BillController do
  use KratosApi.Web, :controller

  # plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  def show(conn, %{"id" => id}) do
    bill =
      KratosApi.Repo.get(KratosApi.Bill, id)
      |> KratosApi.Repo.preload([:subjects, :sponsor, :cosponsors, :committees, :related_bills, :tallies])
      |> KratosApi.Repo.preload(sponsor: :roles)
      |> KratosApi.Repo.preload(cosponsors: :roles)
      |> KratosApi.Repo.preload(tallies: [:votes, votes: :person])
    render conn, "bill.json", bill: bill
  end

end
