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
    assert response["data"] == []
  end

  test "GET /congress/house/floor with a specific date", %{conn: conn, jwt: jwt} do
    KratosApi.Sync.Floor.sync(:house)

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/congress/house/floor?date=2017-06-23")

    response = json_response(conn, 200)

    assert response
    assert response["data"]
    assert response["data"] |> Enum.count == 51

    [first | _rest] = response["data"]
    assert first["title"] == "Legislative Day Of June 23, 2017  - 12:51:58 P.M."
    assert first["description"] == "\nThe House adjourned pursuant to a previous special order. The next meeting is scheduled for 12:00 p.m. on June 26, 2017.\n"
    assert first["link"] == "http://clerk.house.gov/floorsummary/floor.aspx?day=20170623"
    assert first["published_at"] == "2017-06-23T16:51:58"
    assert first["chamber"] == "house"
  end

  test "GET /congress/senate/floor with a specific date", %{conn: conn, jwt: jwt} do
    KratosApi.Sync.Floor.sync(:senate)

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/congress/senate/floor?date=2017-06-23")

    response = json_response(conn, 200)

    assert response
    assert response["data"]
  end
end
