defmodule KratosApi.BillController do
  use KratosApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  def show(conn, %{"id" => id}) do
    bill = Govtrack.bill(id).body

    extract_party_and_state = ~r/\[(?<party>[A-Z])-(?<state>\w+)/

    sponsor_update =
      Map.put(bill["sponsor"], "image", "#{Application.get_env(:kratos_api, :assets_url)}/225x275/#{bill["sponsor"]["bioguideid"]}.jpg")
      |> Map.put("state", Regex.named_captures(extract_party_and_state, bill["sponsor"]["name"])["state"])
      |> Map.put("party", Regex.named_captures(extract_party_and_state, bill["sponsor"]["name"])["party"])

    cosponsors_update =
      Enum.map(bill["cosponsors"], &(Map.put(&1, "image","#{Application.get_env(:kratos_api, :assets_url)}/225x275/#{&1["bioguideid"]}.jpg")))
      |> Enum.map(&(Map.put(&1, "state", Regex.named_captures(extract_party_and_state, &1["name"])["state"])))
      |> Enum.map(&(Map.put(&1, "party", Regex.named_captures(extract_party_and_state, &1["name"])["party"])))

    updated_bill = bill |> Map.merge(%{"sponsor" => sponsor_update}) |> Map.merge(%{"cosponsors" => cosponsors_update})
    json conn, updated_bill
  end

end
