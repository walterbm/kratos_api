defmodule KratosApi.VoteControllerTest do
  use KratosApi.ConnCase
  import Ecto.Query

  setup do
    KratosApi.Sync.Person.sync
    KratosApi.Sync.sync(:bill)
    :timer.sleep(100)
    KratosApi.Sync.sync(:tally)
    :timer.sleep(600)

    changeset = KratosApi.User.changeset(%KratosApi.User{}, KratosApi.Teststubs.user)
    {:ok, user} = KratosApi.Repo.insert(changeset)
    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)
    %{jwt: jwt}
  end


  test "GET /api/people/:id/votes", %{conn: conn, jwt: jwt} do
    person = KratosApi.Repo.one!(from p in KratosApi.Person, where: p.bioguide == "B000944")
    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/people/#{person.id}/votes")

    response = json_response(conn, 200)
    first_vote = response["data"]["voting_record"] |> List.first
    assert first_vote["value"] == "Nay"
    assert first_vote["tally"]["question"] == "On Cloture on the Motion to Proceed H.R. 5293"
  end
end
