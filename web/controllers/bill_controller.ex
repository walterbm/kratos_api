defmodule KratosApi.BillController do
  use KratosApi.Web, :controller

  def show(conn, %{"id" => id}) do
    json conn, Govtrack.bill(id).body
  end

end
