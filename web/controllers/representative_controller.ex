defmodule KratosApi.RepresentativeController do
  use KratosApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  def show(conn, %{"id" => id}) do
    voting_record =
    Govtrack.vote_voters([person: id, order_by: "-created", limit: 100]).body["objects"]
    |> Enum.map(&(Map.merge(&1["option"], &1["vote"])))
    |> Enum.filter(&(&1["category"] != "cloture"))
    |> Enum.filter(&(&1["category"] != "procedural"))
    |> Enum.map( &(Map.put(&1, "question_title", List.last(Regex.split(~r/: /, &1["question"])) )))
    |> Enum.map( &(Map.put(&1, "question_code", List.first(Regex.split(~r/: /, &1["question"])) )))
    json conn, voting_record
  end

end
