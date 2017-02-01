defmodule KratosApi.ForgotPasswordController do
  use KratosApi.Web, :controller

  alias KratosApi.{
    Repo,
    User,
    Mailer,
    Time
  }

  @token_gen Application.get_env(:kratos_api, :token_gen)

  def forgot_password(conn, %{"email" => email}) do
    email = String.downcase(email)
    reset_token = generate_token(email)

    Email.forgot_password_email(email, reset_token) |> Mailer.deliver_now

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
