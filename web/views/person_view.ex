defmodule KratosApi.PersonView do
  use KratosApi.Web, :view
  import Kerosene.JSON

  def render("persons.json", %{persons: persons}) do
    %{data: render_many(persons, KratosApi.PersonView, "person.json", as: :person)}
  end

  def render("person.json", %{person: person}) do
    terms =
      case person.terms do
        %Ecto.Association.NotLoaded{} -> []
        _ -> Enum.sort(person.terms, &(&1.end >= &2.end))
      end

    %{
      id: person.id,
      bioguide: person.bioguide,
      thomas: person.thomas,
      lis: person.lis,
      opensecrets: person.opensecrets,
      votesmart: person.votesmart,
      cspan: person.cspan,
      wikipedia: person.wikipedia,
      house_history: person.house_history,
      ballotpedia: person.ballotpedia,
      maplight: person.maplight,
      icpsr: person.icpsr,
      wikidata: person.wikidata,
      google_entity_id: person.google_entity_id,
      first_name: person.first_name,
      last_name: person.last_name,
      official_full_name: person.official_full_name,
      birthday: person.birthday,
      gender: person.gender,
      religion: person.religion,
      twitter: person.twitter,
      twitter_id: person.twitter_id,
      facebook: person.facebook,
      facebook_id: person.facebook_id,
      youtube: person.youtube,
      youtube_id: person.youtube_id,
      instagram: person.instagram,
      instagram_id: person.instagram_id,
      image_url: person.image_url,
      bio: person.bio,
      is_current: person.is_current,
      current_office: person.current_office,
      current_state: person.current_state,
      current_district: person.current_district,

      terms: render_many(terms, KratosApi.TermView, "term.json")
    }
  end

  def render("voting_records.json", %{voting_records: voting_records, kerosene: kerosene, conn: conn}) do
    %{
      data: %{
        voting_record: render_many(voting_records, KratosApi.VoteView, "vote_record.json", as: :vote),
      },
      pagination: paginate(conn, kerosene)
    }
  end

  def render("person_light.json", %{person: person}) do
    %{
      id: person.id,
      first_name: person.first_name,
      last_name: person.last_name,
      image_url: person.image_url,
      is_current: person.is_current,
      current_office: person.current_office,
      current_state: person.current_state,
      current_district: person.current_district,
    }
  end

end
