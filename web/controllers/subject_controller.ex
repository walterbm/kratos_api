defmodule KratosApi.SubjectController do
  use KratosApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  def index(conn, _params) do
    subjects = KratosApi.Repo.all(KratosApi.Subject)

    render(conn, KratosApi.SubjectView, "subjects.json", subjects: subjects)
  end

end
