defmodule KratosApi.TallyController do
  use KratosApi.Web, :controller

  alias KratosApi.{
    Repo,
    Tally
  }

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  def show(conn, %{"id" => id}) do
    tally  =
      Repo.get(Tally, id)
      |> Repo.preload([:votes, votes: :person])

    render conn, "tally.json", tally: tally
  end

end
