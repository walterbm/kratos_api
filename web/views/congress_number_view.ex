defmodule KratosApi.CongressNumberView do
  use KratosApi.Web, :view

  def render("congress_number.json", %{congress_number: congress_number}) do
      congress_number.number
  end

end
