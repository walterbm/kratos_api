defmodule KratosApi.UserSubjectControllerTest do
  use KratosApi.ConnCase

  alias KratosApi.{
    Repo,
    User,
    Bill,
    Sync,
    Subject,
    UserSubject,
  }

  setup do
    Sync.sync(:bill)
    subject = Repo.all(from b in Bill, preload: [:top_subject])
              |> List.first
              |> Map.get(:top_subject)

    user = Repo.insert!(User.changeset(%User{}, KratosApi.Teststubs.user))
    Repo.insert!(%UserSubject{user_id: user.id, subject_id: subject.id})

    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)
    %{jwt: jwt}
  end

  test "current user can get all the subject they are following", %{conn: conn, jwt: jwt} do
    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/me/subjects")

    assert json_response(conn, 200)
    response = json_response(conn, 200) |> Map.get("data")
    assert response |> Enum.map(&(Map.get(&1, "name"))) == ["Health"]
  end

  test "current user can follow a new subject", %{conn: conn, jwt: jwt} do
    subject = Repo.all(Subject) |> List.first
    user = Repo.get_by(User, email: KratosApi.Teststubs.user.email)
    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> put_req_header("content-type", "application/json")
      |> post("/api/me/subjects", Poison.encode!(%{follow: %{subject_id: subject.id}}))

    assert json_response(conn, 200) == %{"following" => subject.name}
    following = Repo.get_by(UserSubject, user_id: user.id)
    assert following.subject_id == subject.id
  end

  test "current user can follow an existing subject without errors", %{conn: conn, jwt: jwt} do
    subject = Repo.all(Subject) |> List.first
    user = Repo.get_by(User, email: KratosApi.Teststubs.user.email)
    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> put_req_header("content-type", "application/json")
      |> post("/api/me/subjects", Poison.encode!(%{follow: %{subject_id: subject.id}}))

    assert json_response(conn, 200) == %{"following" => subject.name}
    following = Repo.get_by(UserSubject, user_id: user.id)
    assert following.subject_id == subject.id

    conn = recycle(conn)
    |> put_req_header("authorization", "Bearer #{jwt}")
    |> put_req_header("content-type", "application/json")
    |> post("/api/me/subjects", Poison.encode!(%{follow: %{subject_id: subject.id}}))

    assert json_response(conn, 200) == %{"following" => subject.name}
    following = Repo.get_by(UserSubject, user_id: user.id)
    assert following.subject_id == subject.id

  end

  test "DELETE /api/me/subjects/:id", %{conn: conn, jwt: jwt} do
    my_subject = Repo.all(UserSubject)
                |> List.first
                |> Repo.preload(:subject)
    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> delete("/api/me/subjects/#{my_subject.subject.id}")

    assert json_response(conn, 200) == %{"ok" => true}
    assert Repo.all(UserSubject) |> Enum.empty?
  end

end
