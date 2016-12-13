defmodule KratosApi.BillController do
  use KratosApi.Web, :controller

  # plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  def show(conn, %{"id" => id}) do
    bill =
      KratosApi.Repo.get(KratosApi.Bill, id)
      |> KratosApi.Repo.preload([:congress_number, :subjects, :sponsor, :cosponsors, :committees])
      |> KratosApi.Repo.preload(sponsor: :roles)
      |> KratosApi.Repo.preload(cosponsors: :roles)
    render conn, "bill.json", bill: bill
  end

end
