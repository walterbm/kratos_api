defmodule KratosApi.RepresentativeController do
  use KratosApi.Web, :controller

  def show(conn, %{"id" => id}) do
    voting_record =
    Govtrack.vote_voters([person: id, order_by: "-created", limit: 100]).body["objects"]
    |> Enum.map(fn(x) -> Map.merge(x["option"], x["vote"]) end)
    |> Enum.filter(fn(x) -> x["category"] != "cloture" end)
    |> Enum.filter(fn(x) -> x["category"] != "procedural" end)
    json conn, voting_record
  end

end
