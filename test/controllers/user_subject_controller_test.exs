defmodule KratosApi.UserSubjectControllerTest do
  use KratosApi.ConnCase

  alias KratosApi.{
    Repo,
    User,
    Sync,
    Subject,
    UserSubject,
  }

  setup do
    Sync.sync(:bill)
    subject = Repo.all(Subject) |> List.first
    user = Repo.insert!(User.changeset(%User{}, KratosApi.Teststubs.user))
    Repo.insert!(%UserSubject{user_id: user.id, subject_id: subject.id})

    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)
    %{jwt: jwt}
  end

  test "GET /api/me/subjects", %{conn: conn, jwt: jwt} do
    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/me/subjects")

    assert json_response(conn, 200)
  end

  test "GET /api/me/subjects/:id", %{conn: conn, jwt: jwt} do
    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/me/subjects/#{3}")

    assert json_response(conn, 200)
  end

  test "POST /api/me/subjects", %{conn: conn, jwt: jwt} do

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> put_req_header("content-type", "application/json")
      |> post("/api/me/subjects", Poison.encode!(%{track: %{subject_id: 3}}))

    assert json_response(conn, 200)
  end

  test "DELETE /api/me/subjects/:id", %{conn: conn, jwt: jwt} do

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> delete("/api/me/subjects/#{3}")

    assert json_response(conn, 200)
  end

end
