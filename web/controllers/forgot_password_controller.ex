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
    reset_token = %{email: email}
      |> @token_gen.token
      |> @token_gen.with_exp
      |> @token_gen.with_signer(@token_gen.hs256(Application.get_env(:joken, :secret_key)))
      |> @token_gen.sign
      |> @token_gen.get_compact

    Email.forgot_password_email(email, reset_token) |> Mailer.deliver_now

    json conn, %{ok: true}
  end

  def reset_password(conn, %{"reset_token" => reset_token}) do
    conn
    |> put_layout(false)
    |> render("reset_password.html", reset_token: reset_token)
  end

  def new_password(conn, %{"reset_token" => reset_token, "password" => password}) do
    verified_token = reset_token
      |> @token_gen.token
      |> @token_gen.with_validation("exp", &(&1 > Time.current))
      |> @token_gen.with_signer(@token_gen.hs256(Application.get_env(:joken, :secret_key)))
      |> @token_gen.verify!

    case verified_token do
      {:ok, claims} ->
        user = Repo.get_by(User, email: claims["email"])
        changeset = User.reset_password_changeset(user, %{password: password})

        case Repo.update(changeset) do
          {:ok, _user} ->
            conn
             |> put_flash(:info, "Password successfully reset!")
             |> put_layout(false)
             |> render("reset_password.html", reset_token: "dummy")

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

end
