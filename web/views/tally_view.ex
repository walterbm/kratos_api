defmodule KratosApi.TallyView do
  use KratosApi.Web, :view

  def render("tally.json", %{tally: tally}) do
    Map.merge(%{
      id: tally.id,
      amendment: tally.amendment,
      treaty: tally.treaty,
      category: tally.category,
      chamber: tally.chamber,
      date: tally.date,
      number: tally.number,
      question: tally.question,
      requires: tally.requires,
      result: tally.result,
      result_text: tally.result_text,
      session: tally.session,
      source_url: tally.source_url,
      subject: tally.subject,
      type: tally.type,
      record_updated_at: tally.record_updated_at,
      gpo_id: tally.gpo_id,
      votes: render_many(tally.votes, KratosApi.VoteView, "vote.json")
    }, KratosApi.Tally.tallyup_votes(tally.votes))
  end

  def render("tally_flat.json", %{tally: tally}) do
    %{
      id: tally.id, 
      amendment: tally.amendment,
      treaty: tally.treaty,
      category: tally.category,
      chamber: tally.chamber,
      date: tally.date,
      number: tally.number,
      question: tally.question,
      requires: tally.requires,
      result: tally.result,
      result_text: tally.result_text,
      session: tally.session,
      source_url: tally.source_url,
      subject: tally.subject,
      type: tally.type,
      record_updated_at: tally.record_updated_at,
      gpo_id: tally.gpo_id,
    }
  end

end
