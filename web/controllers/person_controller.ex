defmodule KratosApi.PersonController do
  use KratosApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  def show(conn, params) do
    query = from p in KratosApi.Person,
      where: p.id == ^params["id"],
      preload: [:terms]

    person = KratosApi.Repo.one!(query)

    render(conn, "person.json", person: person)
  end

end
