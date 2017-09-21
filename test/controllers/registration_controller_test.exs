defmodule KratosApi.RegistrationControllerTest do
  use KratosApi.ConnCase
  use Bamboo.Test

  alias KratosApi.{
    Repo,
    User,
    TokenGen,
    Teststubs
  }

  setup do
    user = Repo.insert!(User.changeset(%User{}, Teststubs.user))
    %{email: user.email}
  end

  test "Create unconfirmed account and send confirmation email", %{conn: conn} do
    conn = conn
      |> put_req_header("content-type", "application/json")
      |> post("/api/registrations", Poison.encode!(Teststubs.kawhi))

    user = Repo.get_by(User, email: Teststubs.kawhi.user.email)
    refute user.confirmed_email_at

    assert_delivered_email Email.confirmation("kawhi@goat.com", TokenGen.InMemory.get_test_token())
    assert json_response(conn, 201) == %{
      "address" => user.address,
      "birthday" => Ecto.Date.to_string(user.birthday),
      "city" => user.city,
      "district" => user.district,
      "email" => user.email,
      "first_name" => user.first_name,
      "id" => user.id,
      "last_name" => user.last_name,
      "party" => user.party,
      "phone" => user.phone,
      "state" => user.state,
      "zip" => user.zip
    }
    assert user.push_token == Teststubs.kawhi.user.push_token
  end

  test "Unconfirmed account cannot get a token", %{conn: conn} do
    conn = conn
      |> put_req_header("content-type", "application/json")
      |> post("/api/registrations", Poison.encode!(Teststubs.kawhi))

    assert json_response(conn, 201)
    assert_delivered_email Email.confirmation(Teststubs.kawhi.user.email, TokenGen.InMemory.get_test_token())

    user = Repo.get_by(User, email: Teststubs.kawhi.user.email)
    refute user.confirmed_email_at

    conn = recycle(conn)
      |> put_req_header("content-type", "application/json")
      |> post("/api/login", Poison.encode!(%{
          session: %{
            email: Teststubs.kawhi.user.email,
            password: Teststubs.kawhi.user.password
          }
        }))

    assert json_response(conn, 422) == %{"errors" => [%{"error" => "Account has not been confirmed"}]}
  end

  test "Confirmed account can get a token", %{conn: conn} do
    conn = conn
      |> put_req_header("content-type", "application/json")
      |> post("/api/registrations", Poison.encode!(KratosApi.Teststubs.kawhi))

    assert json_response(conn, 201)
    assert_delivered_email Email.confirmation(Teststubs.kawhi.user.email, TokenGen.InMemory.get_test_token())

    user = Repo.get_by(User, email: Teststubs.kawhi.user.email)
    refute user.confirmed_email_at

    KratosApi.UserAnalytics.confirm_email(user)

    user = Repo.get_by(User, email: Teststubs.kawhi.user.email)
    assert user.confirmed_email_at

    conn = recycle(conn)
      |> put_req_header("content-type", "application/json")
      |> post("/api/login", Poison.encode!(%{
          session: %{
            email: Teststubs.kawhi.user.email,
            password: Teststubs.kawhi.user.password
          }
        }))

    assert json_response(conn, 201)
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
