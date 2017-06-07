defmodule KratosApi.SessionControllerTest do
  use KratosApi.ConnCase

  alias KratosApi.{
    User,
    Teststubs,
    UserAnalytics
  }

  setup do
    user = Repo.insert!(User.changeset(%User{}, Teststubs.user))
    UserAnalytics.confirm_email(user)
    %{email: user.email, password: user.password }
  end

  test "login with valid credentials", %{conn: conn, email: email, password: password} do
    conn = conn
      |> put_req_header("content-type", "application/json")
      |> post("/api/login", Poison.encode!(%{
        session: %{ email: email, password: password }
      }))

    response = json_response(conn, 201)
    assert response
    assert Map.has_key?(response, "token")

    jwt = Map.get(response, "token")

    conn = recycle(conn)
      |> put_req_header("content-type", "application/json")
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/me/")

    assert json_response(conn, 200)
  end

  test "fail to login with bunk credentials", %{conn: conn} do
    conn = conn
      |> put_req_header("content-type", "application/json")
      |> post("/api/login", Poison.encode!(%{
        session: %{ email: "mike@jones.com", password: "who?" }
      }))

    response = json_response(conn, 422)
    assert response == %{"errors" => [%{"error" => "Invalid email or password"}]}
  end
end
