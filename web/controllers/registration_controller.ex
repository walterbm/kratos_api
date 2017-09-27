defmodule KratosApi.RegistrationController do
  use KratosApi.Web, :controller

  alias KratosApi.{
    Repo,
    User,
    Mailer,
    Time,
    ErrorView,
    UserAnalytics,
  }

  @token_gen Application.get_env(:kratos_api, :token_gen)
  @find_district Application.get_env(:kratos_api, :remote_district_lookup)

  plug :scrub_params, "user" when action in [:create]

  def create(conn, %{"user" => user_params}) do
    new_user = case @find_district.by_address(user_params) do
      {:ok, address} ->
         Map.merge(user_params, address)
      {:error, _}    ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ErrorView, "bad_address.json")
    end

    changeset = User.changeset(%User{}, new_user)

    case Repo.insert(changeset) do
      {:ok, user} ->

        Email.confirmation(user.email, user.pin) |> Mailer.deliver_now

        conn
        |> put_status(:created)
        |> render(KratosApi.UserView, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
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
    with  {:ok, claims} <- verify_token(reset_token),
          {:ok, _user}  <-
            Repo.get_by(User, email: claims["email"])
            |> User.reset_password_changeset(%{password: password})
            |> Repo.update
    do
      conn
       |> put_layout(false)
       |> render("new_password.html")

    else
      _ -> conn
       |> put_flash(:error, "Password failed to update")
       |> put_layout(false)
       |> render("reset_password.html", reset_token: reset_token)
    end
  end

  def confirm_request(conn, %{"email" => email}) do
    email = String.downcase(email)

    user = Repo.get_by(User, email: email)

    if user do
      Email.confirmation(email, user.pin) |> Mailer.deliver_now
    end

    json conn, %{ok: true}
  end

  def confirm(conn, %{"pin" => pin}) do
    case Repo.get_by(User, pin: pin) do
      nil  ->
        conn
          |> put_flash(:error, "Failed to confirm account!")
          |> put_layout(false)
          |> render("confirm_email.html")
      user ->
        UserAnalytics.confirm_email(user)
        conn
          |> put_flash(:success, "Confirmed account!")
          |> put_layout(false)
          |> render("confirm_email.html")
    end
  end

  def confirm_post(conn, %{"pin" => pin}) do
    case Repo.get_by(User, pin: pin) do
      nil  ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid PIN, please try again."})
      user ->
        UserAnalytics.confirm_email(user)
        json conn, %{success: "Confirmed account!"}
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

  defp verify_token(token) do
    token
      |> @token_gen.token
      |> @token_gen.with_validation("exp", &(&1 > Time.current))
      |> @token_gen.with_signer(@token_gen.hs256(Application.get_env(:joken, :secret_key)))
      |> @token_gen.verify!
  end

end
