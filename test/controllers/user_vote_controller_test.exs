defmodule KratosApi.UserVoteControllerTest do
  use KratosApi.ConnCase

  alias KratosApi.{
    Repo,
    User,
    Tally,
    UserVote
  }

  setup do
    KratosApi.Sync.Tally.sync
    tally = Repo.all(Tally) |> List.first
    user = Repo.insert!(User.changeset(%User{}, KratosApi.Teststubs.user))
    _vote = Repo.insert!(%UserVote{user_id: user.id, tally_id: tally.id, value: "Aye", })

    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)
    %{jwt: jwt}
  end

  test "GET /api/me/votes", %{conn: conn, jwt: jwt} do
    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/me/votes")

    one = json_response(conn, 200)["data"]["voting_record"] |> List.first
    assert one["value"] == "Aye"
    assert one["tally"]["chamber"] == "House"
    assert one["tally"]["category"] == "passage-suspension"
    assert one["tally"]["number"] == 593
    assert one["tally"]["question"] == "On Motion to Suspend the Rules and Pass: H R 6393 Intelligence Authorization Act for Fiscal Year 2017"
    assert one["tally"]["requires"] == "2/3"
    assert one["tally"]["result"] == "Passed"
    assert one["tally"]["result_text"] == "Passed"
    assert one["tally"]["session"] == "2016"
    assert one["tally"]["subject"] == "Intelligence Authorization Act for Fiscal Year 2017"
    assert one["tally"]["type"] == "On Motion to Suspend the Rules and Pass"
  end

  test "GET /api/me/votes/:id", %{conn: conn, jwt: jwt} do
    vote = Repo.all(UserVote) |> List.first

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/me/votes/#{vote.id}")

    voting_record = json_response(conn, 200)
    assert voting_record["id"] == vote.id
    assert voting_record["value"] == "Aye"
    assert voting_record["tally"]["chamber"] == "House"
    assert voting_record["tally"]["category"] == "passage-suspension"
    assert voting_record["tally"]["number"] == 593
    assert voting_record["tally"]["question"] == "On Motion to Suspend the Rules and Pass: H R 6393 Intelligence Authorization Act for Fiscal Year 2017"
    assert voting_record["tally"]["requires"] == "2/3"
    assert voting_record["tally"]["result"] == "Passed"
    assert voting_record["tally"]["result_text"] == "Passed"
    assert voting_record["tally"]["session"] == "2016"
    assert voting_record["tally"]["subject"] == "Intelligence Authorization Act for Fiscal Year 2017"
    assert voting_record["tally"]["type"] == "On Motion to Suspend the Rules and Pass"
  end

  test "POST /api/me/votes", %{conn: conn, jwt: jwt} do
    Repo.delete_all(UserVote)
    tally = Repo.all(Tally) |> List.first

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> put_req_header("content-type", "application/json")
      |> post("/api/me/votes", Poison.encode!(%{vote: %{tally_id: tally.id, value: "Nay"}}))

      voting_record = json_response(conn, 200)
      assert voting_record["value"] == "Nay"
      assert voting_record["tally"]["chamber"] == "House"
      assert voting_record["tally"]["category"] == "passage-suspension"
      assert voting_record["tally"]["number"] == 593
      assert voting_record["tally"]["question"] == "On Motion to Suspend the Rules and Pass: H R 6393 Intelligence Authorization Act for Fiscal Year 2017"
      assert voting_record["tally"]["requires"] == "2/3"
      assert voting_record["tally"]["result"] == "Passed"
      assert voting_record["tally"]["result_text"] == "Passed"
      assert voting_record["tally"]["session"] == "2016"
      assert voting_record["tally"]["subject"] == "Intelligence Authorization Act for Fiscal Year 2017"
      assert voting_record["tally"]["type"] == "On Motion to Suspend the Rules and Pass"

  end

  test "PATCH /api/me/votes/:id", %{conn: conn, jwt: jwt} do
    vote = Repo.all(UserVote) |> List.first

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> put_req_header("content-type", "application/json")
      |> patch("/api/me/votes/#{vote.id}", Poison.encode!(%{vote: %{value: "Abstain"}}))

      voting_record = json_response(conn, 200)
      assert voting_record["id"] == vote.id
      assert voting_record["value"] == "Abstain"
      assert voting_record["tally"]["chamber"] == "House"
      assert voting_record["tally"]["category"] == "passage-suspension"
      assert voting_record["tally"]["number"] == 593
      assert voting_record["tally"]["question"] == "On Motion to Suspend the Rules and Pass: H R 6393 Intelligence Authorization Act for Fiscal Year 2017"
      assert voting_record["tally"]["requires"] == "2/3"
      assert voting_record["tally"]["result"] == "Passed"
      assert voting_record["tally"]["result_text"] == "Passed"
      assert voting_record["tally"]["session"] == "2016"
      assert voting_record["tally"]["subject"] == "Intelligence Authorization Act for Fiscal Year 2017"
      assert voting_record["tally"]["type"] == "On Motion to Suspend the Rules and Pass"

  end

  test "DELETE /api/me/votes/:id", %{conn: conn, jwt: jwt} do
    vote = Repo.all(UserVote) |> List.first

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> delete("/api/me/votes/#{vote.id}")

    assert json_response(conn, 200) == %{"ok" => true}
    assert Repo.all(UserVote) |> Enum.empty?
  end

end
