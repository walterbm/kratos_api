defmodule KratosApi.CurrentUserControllerTest do
  use KratosApi.ConnCase

  alias KratosApi.{
    Repo,
    User,
    Teststubs,
  }

  setup do
    user = Repo.insert!(User.changeset(%User{}, Teststubs.user))

    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)
    %{jwt: jwt}
  end

  test "current user can update their information", %{conn: conn, jwt: jwt} do
    user = Repo.get_by(User, email: Teststubs.user.email)
    assert user.push_token == nil

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> put_req_header("content-type", "application/json")
      |> post("/api/me", Poison.encode!(%{user: %{first_name: "Kobe", last_name: "Bryant", push_token: "imacomputer"}}))

    assert json_response(conn, 201)
    reponse = json_response(conn, 201)

    assert reponse["first_name"] == "Kobe"
    assert reponse["last_name"] == "Bryant"
    assert reponse["has_push_token"] == true
    assert reponse["address"] == "1 AT&T Center Parkway"
  end

end
