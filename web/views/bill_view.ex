defmodule KratosApi.BillView do
  use KratosApi.Web, :view

  def render("bill.json", %{bill: bill}) do
    %{
      actions: bill.actions,
      amendments: bill.amendments,
      gpo_id: bill.gpo_id,
      type: bill.type,
      committee_history: bill.committee_history,
      enacted_as: bill.enacted_as,
      active: bill.active,
      awaiting_signature: bill.awaiting_signature,
      enacted: bill.enacted,
      vetoed: bill.vetoed,
      history: bill.history,
      introduced_at: bill.introduced_at,
      number: bill.number,
      official_title: bill.official_title,
      popular_title: bill.popular_title,
      short_title: bill.short_title,
      status: bill.status,
      status_at: bill.status_at,
      top_term: bill.top_term,
      summary_text: bill.summary_text,
      summary_date: bill.summary_date,
      titles: bill.titles,
      gpo_data_updated_at: bill.gpo_data_updated_at,
      urls: bill.urls,
      congress_number: bill.congress_number_id,

      sponsor: render_one(bill.sponsor, KratosApi.PersonView, "person.json"),

      committees: render_many(bill.committees, KratosApi.CommitteeView, "committee.json"),
      cosponsors: render_many(bill.cosponsors, KratosApi.PersonView, "person.json"),
      subjects: render_many(bill.subjects, KratosApi.SubjectView, "subject.json"),
      related_bills: render_many(bill.related_bills, KratosApi.RelatedBillView, "related_bill.json"),
      tallies: render_many(bill.tallies, KratosApi.TallyView, "tally.json")
    }
  end

end
