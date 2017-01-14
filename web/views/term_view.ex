defmodule KratosApi.TermView do
  use KratosApi.Web, :view

  def render("terms.json", %{terms: terms}) do
    %{data: render_many(terms, KratosApi.TermView, "term.json", as: :term)}
  end

  def render("term.json", %{term: term}) do
    %{
      id: term.id,
      type: term.type,
      start: term.start,
      end: term.end,
      state: term.state,
      district: term.district,
      class: term.class,
      state_rank: term.state_rank,
      party: term.party,
      caucus: term.caucus,
      party_affiliations: term.party_affiliations,
      url: term.url,
      address: term.address,
      phone: term.phone,
      fax: term.fax,
      contact_form: term.contact_form,
      office: term.office,
      rss_url: term.rss_url,
      is_current: term.is_current,
    }
  end

end
