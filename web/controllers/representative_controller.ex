defmodule KratosApi.RepresentativeController do
  use KratosApi.Web, :controller

  alias KratosApi.{
    Repo
  }

  # plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  def show(conn, params) do
    person = Repo.get!(KratosApi.Person, params["id"]) |> Repo.preload(:roles)

    query = from v in KratosApi.Vote,
      where: v.person_id == ^params["id"],
      preload: [:tally]

    {voting_records, kerosene} = query |> KratosApi.Repo.paginate(params)

    render(conn, KratosApi.PersonView, "voting_records.json", person: person, voting_records: voting_records, kerosene: kerosene)
  end

end
