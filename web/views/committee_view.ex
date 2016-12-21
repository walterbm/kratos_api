defmodule KratosApi.CommitteeView do
  use KratosApi.Web, :view

  def render("committees.json", %{committees: committees}) do
    %{data: render_many(committees, KratosApi.CommitteeView, "committee.json", as: :committee)}
  end

  def render("committee.json", %{committee: committee}) do
    %{
      id: committee.id,
      code: committee.code,
      abbrev: committee.abbrev,
      name: committee.name,
      govtrack_id: committee.govtrack_id,
      committee_type: committee.committee_type,
      committee_type_label: committee.committee_type_label,
      jurisdiction: committee.jurisdiction,
      jurisdiction_link: committee.jurisdiction_link,
      obsolete: committee.obsolete,
      url: committee.url,
      parent: [],
      sub_committees: [],
    }
  end

end
