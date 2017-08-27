defmodule KratosApi.VoteControllerTest do
  use KratosApi.ConnCase
  import Ecto.Query

  setup do
    KratosApi.Sync.Person.sync
    KratosApi.Sync.sync(:bill)
    KratosApi.Sync.sync(:tally)

    changeset = KratosApi.User.changeset(%KratosApi.User{}, KratosApi.Teststubs.user)
    {:ok, user} = KratosApi.Repo.insert(changeset)
    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)
    %{jwt: jwt}
  end


  test "GET /api/people/:id/votes", %{conn: conn, jwt: jwt} do
    person = KratosApi.Repo.one!(from p in KratosApi.Person, where: p.bioguide == "B000575")
    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/people/#{person.id}/votes")

    response = json_response(conn, 200)
    vote = response["data"]["voting_record"] |> Enum.find(fn vote -> vote["tally"]["gpo_id"] == "hr3608-114.2016" end)
    assert vote["value"] == "Yea"
    assert vote["tally"]["question"] == "On Motion to Suspend the Rules and Pass: H R 6393 Intelligence Authorization Act for Fiscal Year 2017"
    assert vote["tally"]["bill"]["gpo_id"] == "hr3608-114"
    assert vote["tally"]["bill"]["top_subject"]["name"] == "Taxation"
  end
end
