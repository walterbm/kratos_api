defmodule KratosApi.CongressControllerTest do
  use KratosApi.ConnCase

  setup do
    KratosApi.Sync.sync(:bill)

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

    assert response["data"]
    assert response["data"] |> Enum.count == 1

    first =
      response["data"]
      |> Enum.filter(fn bill -> bill["gpo_id"] == "hr3608-114" end)
      |> List.first

    assert first["official_title"] == "To amend the Internal Revenue Code of 1986 to exempt amounts paid for aircraft management services from the excise taxes imposed on transportation by air."
    assert first["type"] == "hr"
    assert first["pretty_gpo"] == "H.R. 3608"
  end

  test "GET /congress/senate/floor", %{conn: conn, jwt: jwt} do
    KratosApi.Sync.Floor.sync(:senate)

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/congress/senate/floor")

    response = json_response(conn, 200)

    assert response["data"]
    assert response["data"] |> Enum.count == 1

    first =
      response["data"]
      |> Enum.filter(fn bill -> bill["gpo_id"] == "hr3608-114" end)
      |> List.first

    assert first["official_title"] == "To amend the Internal Revenue Code of 1986 to exempt amounts paid for aircraft management services from the excise taxes imposed on transportation by air."
    assert first["type"] == "hr"
    assert first["pretty_gpo"] == "H.R. 3608"
  end
end
