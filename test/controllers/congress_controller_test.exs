defmodule KratosApi.CongressControllerTest do
  use KratosApi.ConnCase

  setup do
    changeset = KratosApi.User.changeset(%KratosApi.User{}, KratosApi.Teststubs.user)
    {:ok, user} = KratosApi.Repo.insert(changeset)
    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)
    %{jwt: jwt}
  end

  test "GET /congress/house/floor", %{conn: conn, jwt: jwt} do
    KratosApi.Sync.Floor.sync(:house)

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/congress/house/floor")

    response = json_response(conn, 200)

    assert response
    assert response["data"]
    assert response["data"] |> Enum.count == 15

    [first | _rest] = response["data"]
    assert first["title"] == "Coast Guard Improvement and Reform Act of 2017"
    assert first["chamber"] == "house"
    assert first["bill_gpo_id"] == "hr1726-115"
    assert first["pretty_bill_gpo_id"] == "H.R. 1726"
  end

  test "GET /congress/senate/floor", %{conn: conn, jwt: jwt} do
    KratosApi.Sync.Floor.sync(:senate)

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/congress/senate/floor")

    response = json_response(conn, 200)

    assert response
    assert response["data"]
    assert response["data"] |> Enum.count == 17

    [first | _rest] = response["data"]
    assert first["title"] == "Abortion, no taxpayer funding"
    assert first["chamber"] == "senate"
    assert first["bill_gpo_id"] == "hr7-115"
    assert first["pretty_bill_gpo_id"] == "H.R.7"
  end
end
