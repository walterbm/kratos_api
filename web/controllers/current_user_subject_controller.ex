defmodule KratosApi.CurrentUserSubjectController do
  use KratosApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  plug :scrub_params, "follow" when action in [:create]

  alias KratosApi.{
    Repo,
    Subject,
    ErrorView,
    SubjectView,
    UserSubject,
  }

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    query = from s in Subject,
      join: following in UserSubject, on: s.id == following.subject_id,
      where: following.user_id == ^user.id

    render(conn, SubjectView, "subjects.json", subjects: Repo.all(query))
  end

  def create(conn, %{"follow" => %{"subject_id" => subject_id} }) do
    user = Guardian.Plug.current_resource(conn)
    following = UserSubject.get_or_create(user.id, subject_id) |> Repo.preload(:subject)

    json conn, %{following: following.subject.name}
  end
  def create(conn, _) do
    render conn, ErrorView, "400.json"
  end

  def delete(conn, %{"id" => subject_id}) do
    user = Guardian.Plug.current_resource(conn)
    query = from s in UserSubject,
        where: s.subject_id == ^subject_id,
        where: s.user_id == ^user.id

    Repo.one!(query) |> Repo.delete!

    json conn, %{ok: true}
  end

end
