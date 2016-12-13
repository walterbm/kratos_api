defmodule KratosApi.SubjectView do
  use KratosApi.Web, :view

  def render("subjects.json", %{subjects: subjects}) do
    %{data: render_many(subjects, KratosApi.SubjectView, "subject.json", as: :subject)}
  end

  def render("subject.json", %{subject: subject}) do
    subject.name
  end

end
