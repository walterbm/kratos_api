defmodule KratosApi.RegistrationController do
  use KratosApi.Web, :controller

  alias KratosApi.{
    Repo,
    User,
    User,
    Mailer,
    Time,
    FindDistrict
  }

  @token_gen Application.get_env(:kratos_api, :token_gen)

  plug :scrub_params, "user" when action in [:create]

  def create(conn, %{"user" => user_params}) do
    new_user = Map.merge(user_params, FindDistrict.by_address(user_params))

    changeset = User.changeset(%User{}, new_user)

    case Repo.insert(changeset) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, :token)

        conn
        |> put_status(:created)
        |> render(KratosApi.SessionView, "show.json", jwt: jwt, user: user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(KratosApi.RegistrationView, "error.json", changeset: changeset)
    end
  end

  def forgot_password(conn, %{"email" => email}) do
    email = String.downcase(email)
    reset_token = generate_token(email)

    Email.forgot_password(email, reset_token) |> Mailer.deliver_now

    json conn, %{ok: true}
  end

  def reset_password(conn, %{"reset_token" => reset_token}) do
    conn
    |> put_layout(false)
    |> render("reset_password.html", reset_token: reset_token)
  end

  def new_password(conn, %{"reset_token" => reset_token, "password" => password}) do
    case verify_token(reset_token) do
      {:ok, claims} ->
        changeset =
          Repo.get_by(User, email: claims["email"])
          |> User.reset_password_changeset(%{password: password})

        case Repo.update(changeset) do
          {:ok, _user} ->
            conn
             |> put_layout(false)
             |> render("new_password.html")

          {:error, _changeset} ->
            conn
             |> put_flash(:error, "Password failed to update")
             |> put_layout(false)
             |> render("reset_password.html", reset_token: reset_token)
        end

      {:error, _message} ->
        conn
         |> put_flash(:error, "Password failed to update")
         |> put_layout(false)
         |> render("reset_password.html", reset_token: reset_token)
    end
  end

  def confirmation_request(conn, %{"email" => email}) do
    email = String.downcase(email)
    token = generate_token(email)

    Email.confirmation(email, token) |> Mailer.deliver_now

    json conn, %{ok: true}
  end

  def confirmation_page(conn, %{"token" => token}) do
    conn
    |> put_layout(false)
    |> render("confirm_email.html", token: token)
  end

  def confirm(conn, %{"confirmation_token" => confirmation_token}) do
    case verify_token(confirmation_token) do
      {:ok, claims} ->
        User
          |> Repo.get_by(email: claims["email"])
          |> User.confirm()
          |> Repo.update!

        conn
         |> put_layout(false)
         |> render("confirmed.html")
      {:error, _message} ->
        conn
          |> put_flash(:error, "Failed to confirm account!")
          |> put_layout(false)
          |> render("failed.html", confirmation_token: confirmation_token)
    end
  end

  defp generate_token(email) do
    %{email: email}
      |> @token_gen.token
      |> @token_gen.with_exp
      |> @token_gen.with_signer(@token_gen.hs256(Application.get_env(:joken, :secret_key)))
      |> @token_gen.sign
      |> @token_gen.get_compact
  end

  defp verify_token(reset_token) do
    reset_token
      |> @token_gen.token
      |> @token_gen.with_validation("exp", &(&1 > Time.current))
      |> @token_gen.with_signer(@token_gen.hs256(Application.get_env(:joken, :secret_key)))
      |> @token_gen.verify!
  end

end
