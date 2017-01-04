defmodule KratosApi.VoteView do
  use KratosApi.Web, :view

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

end
