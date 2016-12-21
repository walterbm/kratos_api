defmodule KratosApi.DistrictView do
  use KratosApi.Web, :view
  import Kerosene.JSON

  def render("representatives.json", %{representatives: representatives, kerosene: kerosene, conn: conn}) do
    %{
      data: render_many(representatives, KratosApi.PersonView, "person.json", as: :person),
      pagination: paginate(conn, kerosene)
    }
  end

end
