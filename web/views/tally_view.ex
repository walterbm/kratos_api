defmodule KratosApi.TallyView do
  use KratosApi.Web, :view

  def render("tally.json", %{tally: tally}) do
    Map.merge(%{
      id: tally.id,
      bill_id: tally.bill_id,
      nomination_id: tally.nomination_id,
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
      bill_official_title: tally.bill_official_title,
      bill_short_title: tally.bill_short_title,
      votes: render_many(tally.votes, KratosApi.VoteView, "vote.json")
    }, KratosApi.Tally.tallyup_votes(tally.votes))
  end

  def render("tally_flat.json", %{tally: tally}) do
    %{
      id: tally.id,
      bill_id: tally.bill_id,
      nomination_id: tally.nomination_id,
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
      subject: tally.subject,
      type: tally.type,
      record_updated_at: tally.record_updated_at,
      gpo_id: tally.gpo_id,
      bill_official_title: tally.bill_official_title,
      bill_short_title: tally.bill_short_title,
    }
  end

end
