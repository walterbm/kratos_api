defmodule KratosApi.BillView do
  use KratosApi.Web, :view
  import Kerosene.JSON

  def render("bill.json", %{bill: bill}) do
    %{
      id: bill.id,
      actions: bill.actions,
      amendments: bill.amendments,
      gpo_id: bill.gpo_id,
      pretty_gpo: bill.pretty_gpo,
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
      summary_text: bill.summary_text |> take_words(500),
      summary_date: bill.summary_date,
      titles: bill.titles,
      gpo_data_updated_at: bill.gpo_data_updated_at,
      source_url: bill.source_url,
      full_text_url: bill.full_text_url,
      congress_number: bill.congress_number_id,

      sponsor: render_one(bill.sponsor, KratosApi.PersonView, "person.json"),
      top_subject: render_one(bill.top_subject, KratosApi.SubjectView, "subject.json"),

      committees: render_many(bill.committees, KratosApi.CommitteeView, "committee.json"),
      cosponsors: render_many(bill.cosponsors, KratosApi.PersonView, "person.json"),
      subjects: render_many(bill.subjects, KratosApi.SubjectView, "subject.json"),
      related_bills: render_many(bill.related_bills, KratosApi.RelatedBillView, "related_bill.json"),
      tallies: render_many(bill.tallies, KratosApi.TallyView, "tally_with_votes.json")
    }
  end

  def render("bill_light.json", %{ bill: bill }) do
    %{
      id: bill.id,
      actions: bill.actions,
      amendments: bill.amendments,
      gpo_id: bill.gpo_id,
      pretty_gpo: bill.pretty_gpo,
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
      summary_text: bill.summary_text |> take_words(500),
      summary_date: bill.summary_date,
      titles: bill.titles,
      gpo_data_updated_at: bill.gpo_data_updated_at,
      source_url: bill.source_url,
      full_text_url: bill.full_text_url,
      congress_number: bill.congress_number_id,
      top_subject: render_one(bill.top_subject, KratosApi.SubjectView, "subject.json"),
    }
  end

  def render("bill_small.json", %{ bill: bill }) do
    %{
      id: bill.id,
      type: bill.type,
      gpo_id: bill.gpo_id,
      actions: bill.actions,
      pretty_gpo: bill.pretty_gpo,
      short_title: bill.short_title,
      popular_title: bill.popular_title,
      official_title: bill.official_title,
      congress_number: bill.congress_number_id,

      top_subject: render_one(bill.top_subject, KratosApi.SubjectView, "subject.json")
    }
  end

  def render("bills.json", %{bills: bills, kerosene: kerosene, conn: conn}) do
    %{
      data: render_many(bills, KratosApi.BillView, "bill_light.json"),
      pagination: paginate(conn, kerosene)
    }
  end
  def render("bills.json", %{bills: bills}) do
    %{
      data: render_many(bills, KratosApi.BillView, "bill_light.json")
    }
  end

  defp take_words(summary_text, number) when length(summary_text) > number do
    summary_text = summary_text
      |> String.split(" ")
      |> Enum.take(number)
      |> Enum.join(" ")
    summary_text <> " . . ."
  end
  defp take_words(summary_text, _number), do: summary_text

end
