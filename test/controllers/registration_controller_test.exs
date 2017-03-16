defmodule KratosApi.RegistrationControllerTest do
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

  test "POST /api/registrations", %{conn: conn} do
    conn = conn
      |> put_req_header("content-type", "application/json")
      |> post("/api/registrations",
        Poison.encode!(%{
          user: %{
            first_name: "Kawhi",
            last_name: "Leonard",
            email: "kawhi@goat.com",
            password: "1stTeamAllDefense",
            address: "1 AT&T Center Parkway",
            city: "San Antonio",
            state: "TX",
            zip: 78219,
            apn_token: "<ce8be627 2e43e855 16033e24 b4c28922 0eeda487 9c477160 b2545e95 b68b5969>"
          }
        })
      )

    assert json_response(conn, 201)
    assert_delivered_email Email.confirmation("kawhi@goat.com", TokenGen.InMemory.get_test_token())
    refute Repo.get_by(User, email: "kawhi@goat.com").confirmed_email_at
  end

  test "POST /api/confirmation/request", %{conn: conn, email: email} do
    conn = conn
      |> put_req_header("content-type", "application/json")
      |> post("/api/confirmation/request", Poison.encode!(%{email: email}))

    assert json_response(conn, 200)
    assert_delivered_email Email.confirmation(email, TokenGen.InMemory.get_test_token())
  end

  test "GET /confirmation", %{conn: conn, email: email} do
    conn = conn |> get("/confirmation?token=#{TokenGen.InMemory.get_test_token()}")
    assert html_response(conn, 200) =~ "Confirmed account!"

    assert Repo.get_by(User, email: email).confirmed_email_at
  end

  test "GET /confirmation with bunk token", %{conn: conn, email: email} do
    conn = conn |> get("/confirmation?token=bunk")
    assert html_response(conn, 200) =~ "Failed to confirm account!"

    refute Repo.get_by(User, email: email).confirmed_email_at
  end

  test "POST /api/forgot-password", %{conn: conn, email: email} do
    conn = conn
      |> put_req_header("content-type", "application/json")
      |> post("/api/forgot-password", Poison.encode!(%{email: email}))

    assert json_response(conn, 200)
    assert_delivered_email Email.forgot_password(email, TokenGen.InMemory.get_test_token())
  end

  test "GET /reset-password", %{conn: conn} do
    conn = conn |> get("/reset-password?reset_token=super-sekrit-password-reset-token")
    assert html_response(conn, 200) =~ "super-sekrit-password-reset-token"
  end

  test "POST /reset-password", %{conn: conn, email: _email} do
    conn = conn
      |> put_req_header("content-type", "application/x-www-form-urlencoded")
      |> post("/reset-password", %{reset_token: TokenGen.InMemory.get_test_token(), password: "new-password"})

    assert html_response(conn, 200) =~ "Password successfully reset!"
  end


end
