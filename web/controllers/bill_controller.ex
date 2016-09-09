defmodule KratosApi.BillController do
  use KratosApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  def show(conn, %{"id" => id}) do
    json conn, Govtrack.bill(id).body
  end

end
