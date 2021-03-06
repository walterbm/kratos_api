defmodule KratosApi.StateControllerTest do
  use KratosApi.ConnCase

  setup do
    KratosApi.Sync.Person.sync

    changeset = KratosApi.User.changeset(%KratosApi.User{}, KratosApi.Teststubs.user)
    {:ok, user} = KratosApi.Repo.insert(changeset)
    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)
    %{jwt: jwt}
  end

  test "get all states with nested districts", %{conn: conn, jwt: jwt} do
    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/states")

    reponse = json_response(conn, 200)
    assert reponse
    assert reponse |> Enum.count == 1
    assert reponse == %{"FL" => [15]}
  end

  test "get single state", %{conn: conn, jwt: jwt} do
    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/states/fl")

    reponse = json_response(conn, 200)
    assert reponse
    assert reponse["districts"]
    assert reponse["districts"] |> List.first == 15
  end
end
