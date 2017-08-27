defmodule KratosApi.TallyController do
  use KratosApi.Web, :controller

  alias KratosApi.{
    Repo,
    Tally
  }

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  def show(conn, %{"id" => id}) do
    query = from tally in Tally,
      where: tally.id == ^id,
      left_join: votes in assoc(tally, :votes),
      left_join: bill in assoc(tally, :bill),
      left_join: person in assoc(votes, :person),
      left_join: top_subject in assoc(bill, :top_subject),
      preload: [bill: {bill, top_subject: top_subject}, votes: {votes, person: person}]

    render conn, "tally.json", tally: Repo.one!(query)
  end

end
