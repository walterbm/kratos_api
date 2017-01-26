defmodule KratosApi.RegistrationController do
  use KratosApi.Web, :controller

  alias KratosApi.{
    Repo,
    User,
    FindDistrict
  }

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
end
