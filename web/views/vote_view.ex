defmodule KratosApi.VoteView do
  use KratosApi.Web, :view

  def render("vote.json", %{vote: vote}) do
    %{
      id: vote.id,
      value: vote.value,
      person_firstname: vote.person.firstname,
      person_lastname: vote.person.lastname,
      person_current_party: vote.person.current_party,
      person_current_state: vote.person.current_state,
      person_image: vote.person.image_url
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
