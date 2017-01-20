defmodule KratosApi.PersonControllerTest do
  use KratosApi.ConnCase
  import Ecto.Query

  setup do
    KratosApi.Sync.Person.sync
    KratosApi.Sync.Person.SocialMedia.sync

    changeset = KratosApi.User.changeset(%KratosApi.User{}, KratosApi.Teststubs.user)
    {:ok, user} = KratosApi.Repo.insert(changeset)
    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)
    %{jwt: jwt}
  end


  test "GET /api/people/:id", %{conn: conn, jwt: jwt} do
    person = KratosApi.Repo.one!(from p in KratosApi.Person, where: p.bioguide == "B000944")
    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/people/#{person.id}")

    response = json_response(conn, 200)
    assert response["youtube_id"] == "UCgy8jfERh-t_ixkKKoCmglQ"
    assert response["youtube"] == "SherrodBrownOhio"
    assert response["wikipedia"] == "Sherrod Brown"
    assert response["wikidata"] == "Q381880"
    assert response["votesmart"] == "27018"
    assert response["twitter_id"] == "43910797"
    assert response["twitter"] == "SenSherrodBrown"
    assert response["thomas"] == "00136"
    assert response["religion"] == "Lutheran"
    assert response["opensecrets"] == "N00003535"
    assert response["official_full_name"] == "Sherrod Brown"
    assert response["maplight"] == "168"
    assert response["lis"] == "S307"
    assert response["last_name"] == "Brown"
    assert response["instagram_id"] == ""
    assert response["instagram"] == ""
    assert response["image_url"] == "https://supersecretdatabase.com/225x275/B000944.jpg"
    assert response["id"] == person.id
    assert response["icpsr"] == "29389"
    assert response["house_history"] == "9996"
    assert response["google_entity_id"] == "kg:/m/034s80"
    assert response["gender"] == "M"
    assert response["first_name"] == "Sherrod"
    assert response["facebook_id"] == ""
    assert response["facebook"] == ""
    assert response["cspan"] == "5051"
    assert response["birthday"] == "1952-11-09"
    assert response["bioguide"] == "B000944"
    assert response["bio"] == nil
    assert response["is_current"] == true
    assert response["current_office"] == "Senate"
    assert response["current_state"] == "OH"
    assert response["current_district"] == nil

    term = response["terms"] |> List.first
    assert term["class"] == "1"
    assert term["district"] == nil
    assert term["end"] == "2019-01-03"
    assert term["is_current"] == nil
    assert term["party_affiliations"] == nil
    assert term["start"] == "2013-01-03"
    assert term["type"] == "Senate"
    assert term["address"] == "713 Hart Senate Office Building Washington DC 20510"
    assert term["caucus"] == nil
    assert term["contact_form"] == "http://www.brown.senate.gov/contact"
    assert term["fax"] == "202-228-6321"
    assert term["office"] == "713 Hart Senate Office Building"
    assert term["party"] == "Democrat"
    assert term["phone"] == "202-224-2315"
    assert term["rss_url"] == "http://www.brown.senate.gov/rss/feeds/?type=all&amp;"
    assert term["state"] == "OH"
    assert term["state_rank"] == "senior"
    assert term["url"] == "https://www.brown.senate.gov"
  end
end
