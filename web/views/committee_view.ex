defmodule KratosApi.CommitteeView do
  use KratosApi.Web, :view

  def render("committees.json", %{committees: committees}) do
    %{data: render_many(committees, KratosApi.CommitteeView, "committee.json", as: :committee)}
  end

  def render("committee.json", %{committee: committee}) do
    %{
      id: committee.id,
      type: committee.type,
      name: committee.name,
      thomas_id: committee.thomas_id,
      senate_committee_id: committee.senate_committee_id,
      house_committee_id: committee.house_committee_id,
      jurisdiction: committee.jurisdiction,
      jurisdiction_source: committee.jurisdiction_source,
      url: committee.url,
      address: committee.address,
      phone: committee.phone,
      rss_url: committee.rss_url,
      minority_rss_url: committee.minority_rss_url,
      past_names: committee.past_names,
    }
  end

end
