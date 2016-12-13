defmodule KratosApi.PersonView do
  use KratosApi.Web, :view

  def render("persons.json", %{persons: persons}) do
    %{data: render_many(persons, KratosApi.PersonView, "person.json", as: :person)}
  end

  def render("person.json", %{person: person}) do
    roles =
      case person.roles do
        %Ecto.Association.NotLoaded{} -> []
        _ -> person.roles
      end

    %{
      govtrack_id: person.govtrack_id,
      cspanid: person.cspanid,
      bioguideid: person.bioguideid,
      birthday: person.birthday,
      firstname: person.firstname,
      gender: person.gender,
      gender_label: person.gender_label,
      lastname: person.lastname,
      link: person.link,
      middlename: person.middlename,
      name: person.name,
      current_party: person.current_party,
      current_state: person.current_state,
      namemod: person.namemod,
      nickname: person.nickname,
      osid: person.osid,
      pvsid: person.pvsid,
      sortname: person.sortname,
      twitterid: person.twitterid,
      youtubeid: person.youtubeid,
      image_url: person.image_url,
      roles: render_many(roles, KratosApi.RoleView, "role.json")
    }
  end

end
