defmodule KratosApi.VoteView do
  use KratosApi.Web, :view
  import Kerosene.JSON

  def render("vote.json", %{vote: vote}) do
    %{
      id: vote.id,
      value: vote.value,
      person: render_one(vote.person, KratosApi.PersonView, "person_light.json")
    }
  end

  def render("vote_record.json", %{vote: vote}) do
    %{
      id: vote.id,
      value: vote.value,
      tally: render_one(vote.tally, KratosApi.TallyView, "tally_flat.json"),
    }
  end

  def render("user_votes.json", %{user_votes: user_votes, kerosene: kerosene, conn: conn}) do
    %{
      data: %{
        voting_record: render_many(user_votes, KratosApi.VoteView, "vote_record.json", as: :vote),
      },
      pagination: paginate(conn, kerosene)
    }
  end

end
