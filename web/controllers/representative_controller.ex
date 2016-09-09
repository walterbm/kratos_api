defmodule KratosApi.RepresentativeController do
  use KratosApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  def show(conn, %{"id" => id}) do
    voting_record =
    Govtrack.vote_voters([person: id, order_by: "-created", limit: 100]).body["objects"]
    |> Enum.map(fn(x) -> Map.merge(x["option"], x["vote"]) end)
    |> Enum.filter(fn(x) -> x["category"] != "cloture" end)
    |> Enum.filter(fn(x) -> x["category"] != "procedural" end)
    |> Enum.map( fn(x) -> Map.put(x, "question_title", List.last(Regex.split(~r/: /, x["question"])) ) end)
    |> Enum.map( fn(x) -> Map.put(x, "question_code", List.first(Regex.split(~r/: /, x["question"])) ) end)
    json conn, voting_record
  end

end
