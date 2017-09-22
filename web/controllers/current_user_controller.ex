defmodule KratosApi.CurrentUserController do
  use KratosApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController
  plug :scrub_params, "user" when action in [:update]
  plug :scrub_params, "user_action" when action in [:record_action]

  alias KratosApi.{
    Repo,
    User,
    UserAction,
    FindDistrict
  }

  def show(conn, _) do
    user = Guardian.Plug.current_resource(conn)

    conn
    |> put_status(:ok)
    |> render("show.json", user: user)
  end

  def update(conn, %{"user" => user_params }) do
    updated_user = Map.merge(user_params, FindDistrict.by_address(user_params))
    changeset = User.update_changeset(Guardian.Plug.current_resource(conn), updated_user)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render("show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(KratosApi.RegistrationView, "error.json", changeset: changeset)
    end
  end

  def record_action(conn, %{"user_action" => user_action }) do
    user = Guardian.Plug.current_resource(conn)
    changeset = UserAction.changeset(%UserAction{}, Map.merge(user_action, %{"user_id" => user.id}))
    Repo.insert!(changeset)

    json conn, %{ok: true}
  end
end
