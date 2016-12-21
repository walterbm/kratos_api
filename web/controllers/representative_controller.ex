defmodule KratosApi.RepresentativeController do
  use KratosApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  def show(conn, params) do
    query = from v in KratosApi.Vote,
      where: v.person_id == ^params["id"],
      join: t in KratosApi.Tally,
      where: v.tally_id == t.id,
      order_by: [desc: t.date],
      preload: [:tally]

    {voting_records, kerosene} = query |> KratosApi.Repo.paginate(params)

    render(conn, KratosApi.PersonView, "voting_records.json", voting_records: voting_records, kerosene: kerosene)
  end

end
