defmodule KratosApi.CurrentUserController do
  use KratosApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController
  plug :scrub_params, "user_action" when action in [:record_action]

  alias KratosApi.{
    Repo,
    UserAction
  }

  def show(conn, _) do
    user = Guardian.Plug.current_resource(conn)

    conn
    |> put_status(:ok)
    |> render("show.json", user: user)
  end

  def record_action(conn, %{"user_action" => user_action }) do
    user = Guardian.Plug.current_resource(conn)
    changeset = UserAction.changeset(%UserAction{}, Map.merge(user_action, %{"user_id" => user.id}))
    Repo.insert!(changeset)

    json conn, %{ok: true}
  end
end
