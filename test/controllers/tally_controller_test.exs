defmodule KratosApi.TallyControllerTest do
  use KratosApi.ConnCase
  import Ecto.Query

  setup do
    KratosApi.Sync.Person.sync
    KratosApi.Sync.Committee.sync
    KratosApi.Sync.sync(:bill)
    KratosApi.Sync.sync(:tally)

    changeset = KratosApi.User.changeset(%KratosApi.User{}, KratosApi.Teststubs.user)
    {:ok, user} = KratosApi.Repo.insert(changeset)
    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)
    %{jwt: jwt}
  end


  test "GET /api/tallies/:id", %{conn: conn, jwt: jwt} do
    tally = KratosApi.Repo.one!(from t in KratosApi.Tally, where: t.gpo_id == "hr3608-114.2016")
    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/tallies/#{tally.id}")

    one = json_response(conn, 200)
    assert one["bill_id"] == tally.bill_id
    assert one["amendment"] == nil
    assert one["treaty"] == nil
    assert one["category"] == "passage-suspension"
    assert one["chamber"] == "House"
    assert one["date"] == "2016-11-30T18:47:00"
    assert one["question"] == "On Motion to Suspend the Rules and Pass: H R 6393 Intelligence Authorization Act for Fiscal Year 2017"
    assert one["requires"] == "2/3"
    assert one["result"] == "Passed"
    assert one["result_text"] == "Passed"
    assert one["session"] == "2016"
    assert one["subject"] == "Intelligence Authorization Act for Fiscal Year 2017"
    assert one["type"] == "On Motion to Suspend the Rules and Pass"
    assert one["gpo_id"] == "hr3608-114.2016"
    assert one["bill_official_title"] == "To amend the Internal Revenue Code of 1986 to exempt amounts paid for aircraft management services from the excise taxes imposed on transportation by air."
    assert one["Yea"] == 4
  end
end
