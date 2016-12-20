defmodule KratosApi.VoteView do
  use KratosApi.Web, :view

  def render("vote.json", %{vote: vote}) do
    %{
      value: vote.value,
      person_name: vote.person.name,
      person_image: vote.person.image_url
    }
  end

  def render("vote_record.json", %{vote: vote}) do
    %{
      value: vote.value,
      tally: render_one(vote.tally, KratosApi.TallyView, "tally_flat.json"),
    }
  end

end
