defmodule KratosApi.DistrictView do
  use KratosApi.Web, :view

  def render("roles.json", %{roles: roles}) do
    %{data: render_many(roles, KratosApi.DistrictView, "role.json", as: :role)}
  end

  def render("role.json", %{role: role}) do
    %{
      current: role.current,
      enddate: role.enddate,
      description: role.description,
      govtrack_id: role.govtrack_id,
      caucus: role.caucus,
      district: role.district,
      extra: role.extra,
      leadership_title: role.leadership_title,
      party: role.party,
      phone: role.phone,
      role_type: role.role_type,
      role_type_label: role.role_type_label,
      senator_class: role.senator_class,
      senator_class_label: role.senator_class_label,
      senator_rank: role.senator_rank,
      senator_rank_label: role.senator_rank_label,
      startdate: role.startdate,
      state: role.state,
      title: role.title,
      title_long: role.title_long,
      website: role.website,
      person: render_one(role.person, KratosApi.PersonView, "person.json"),
      congress_numbers: render_many(role.congress_numbers, KratosApi.CongressNumberView, "congress_number.json"),
    }
  end

end
