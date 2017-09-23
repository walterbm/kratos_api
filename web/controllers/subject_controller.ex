defmodule KratosApi.SubjectController do
  use KratosApi.Web, :controller

  alias KratosApi.{
    Repo,
    Bill,
    Subject,
    SubjectView
  }

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  def index(conn, %{"active" => "true"}) do
    query = from bill in Bill,
      distinct: bill.top_subject_id,
      join: subject in Subject,
      on: subject.id == bill.top_subject_id,
      order_by: subject.name,
      select: subject

    subjects = Repo.all(query)

    render(conn, SubjectView, "subjects.json", subjects: subjects)
  end

  def index(conn, _params) do
    subjects =
      Repo.all(Subject)
      |> Enum.sort(&(&1.name <= &2.name))

    render(conn, SubjectView, "subjects.json", subjects: subjects)
  end

end
