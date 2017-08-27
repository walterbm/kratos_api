defmodule KratosApi.VoteController do
  use KratosApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  def index(conn, params) do
    query = from vote in KratosApi.Vote,
      where: vote.person_id == ^params["id"],
      left_join: tally in assoc(vote, :tally),
      left_join: bill in assoc(tally, :bill),
      left_join: top_subject in assoc(bill, :top_subject),
      preload: [tally: {tally, bill: {bill, top_subject: top_subject}}],
      order_by: [desc: tally.date]

    {voting_records, kerosene} = query |> KratosApi.Repo.paginate(params)

    render(conn, KratosApi.VoteView, "voting_records.json", voting_records: voting_records, kerosene: kerosene)
  end

end
