defmodule KratosApi.ForgotPasswordControllerTest do
  use KratosApi.ConnCase
  use Bamboo.Test

  alias KratosApi.{
    Repo,
    User,
    TokenGen
  }

  setup do
    user = Repo.insert!(User.changeset(%User{}, KratosApi.Teststubs.user))
    %{email: user.email}
  end

  test "POST /api/forgot-password", %{conn: conn, email: email} do
    conn = conn
      |> put_req_header("content-type", "application/json")
      |> post("/api/forgot-password", Poison.encode!(%{email: email}))

    assert json_response(conn, 200)
    assert_delivered_email Email.forgot_password_email(email, TokenGen.InMemory.get_reset_token())
  end

  test "GET /reset-password", %{conn: conn} do
    conn = conn |> get("/reset-password?reset_token=super-sekrit-password-reset-token")
    assert html_response(conn, 200) =~ "super-sekrit-password-reset-token"
  end

  test "POST /reset-password", %{conn: conn, email: _email} do
    conn = conn
      |> put_req_header("content-type", "application/x-www-form-urlencoded")
      |> post("/reset-password", %{reset_token: TokenGen.InMemory.get_reset_token(), password: "new-password"})

    assert html_response(conn, 200) =~ "Password successfully reset!"
  end


end
