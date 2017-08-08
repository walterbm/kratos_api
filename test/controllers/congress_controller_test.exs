defmodule KratosApi.CongressControllerTest do
  use KratosApi.ConnCase

  setup do
    KratosApi.Sync.sync(:bill)

    changeset = KratosApi.User.changeset(%KratosApi.User{}, KratosApi.Teststubs.user)
    {:ok, user} = KratosApi.Repo.insert(changeset)
    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)
    %{jwt: jwt}
  end

  @tag :wip
  test "GET /congress/house/floor", %{conn: conn, jwt: jwt} do
    KratosApi.Sync.Floor.sync(:house)

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/congress/house/floor")

    response = json_response(conn, 200)

    assert response
    assert response["data"]
    assert response["data"] |> Enum.count == 15

    first =
      response["data"]
      |> Enum.filter(fn activity -> activity["title"] == "Santa Ana River Wash Plan Land Exchange Act" end)
      |> List.first

    assert first["title"] == "Santa Ana River Wash Plan Land Exchange Act"
    assert first["chamber"] == "house"
    assert first["bill"]["pretty_gpo"] == "H.R. 3608"
    assert first["bill"]["gpo_id"] == "hr3608-114"
  end

  @tag :wip
  test "GET /congress/senate/floor", %{conn: conn, jwt: jwt} do
    KratosApi.Sync.Floor.sync(:senate)

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/congress/senate/floor")

    response = json_response(conn, 200)

    assert response
    assert response["data"]
    assert response["data"] |> Enum.count == 17

    first =
      response["data"]
      |> Enum.filter(fn activity -> activity["title"] == "Health care, repeal and replace ACA" end)
      |> List.first

    assert first["title"] == "Health care, repeal and replace ACA"
    assert first["chamber"] == "senate"
    assert first["bill"]["pretty_gpo"] == "H.R. 3608"
    assert first["bill"]["gpo_id"] == "hr3608-114"
  end
end
