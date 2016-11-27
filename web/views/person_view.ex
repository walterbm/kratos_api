defmodule KratosApi.PersonView do
  use KratosApi.Web, :view

  def render("person.json", %{person: person}) do
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
      namemod: person.namemod,
      nickname: person.nickname,
      osid: person.osid,
      pvsid: person.pvsid,
      sortname: person.sortname,
      twitterid: person.twitterid,
      youtubeid: person.youtubeid,
      image_url: person.image_url
    }
  end

end
