defmodule KratosApi.DistrictControllerTest do
  use KratosApi.ConnCase

  setup do
    KratosApi.Sync.Person.sync
    KratosApi.Sync.Person.SocialMedia.sync

    changeset = KratosApi.User.changeset(%KratosApi.User{}, KratosApi.Teststubs.user)
    {:ok, user} = KratosApi.Repo.insert(changeset)
    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)
    %{jwt: jwt}
  end


  test "GET /api/districts/:state/:district", %{conn: conn, jwt: jwt} do
    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/districts/oh/1")

    one = json_response(conn, 200)["data"] |> List.first
    assert one["youtube_id"] == "UCgy8jfERh-t_ixkKKoCmglQ"
    assert one["youtube"] == "SherrodBrownOhio"
    assert one["wikipedia"] == "Sherrod Brown"
    assert one["wikidata"] == "Q381880"
    assert one["votesmart"] == "27018"
    assert one["twitter_id"] == "43910797"
    assert one["twitter"] == "SenSherrodBrown"
    assert one["thomas"] == "00136"
    assert one["religion"] == "Lutheran"
    assert one["opensecrets"] == "N00003535"
    assert one["official_full_name"] == "Sherrod Brown"
    assert one["maplight"] == "168"
    assert one["lis"] == "S307"
    assert one["last_name"] == "Brown"
    assert one["instagram_id"] == ""
    assert one["instagram"] == ""
    assert one["image_url"] == "https://supersecretdatabase.com/225x275/B000944.jpg"
    assert one["icpsr"] == "29389"
    assert one["house_history"] == "9996"
    assert one["google_entity_id"] == "kg:/m/034s80"
    assert one["gender"] == "M"
    assert one["first_name"] == "Sherrod"
    assert one["facebook_id"] == ""
    assert one["facebook"] == ""
    assert one["cspan"] == "5051"
    assert one["birthday"] == "1952-11-09"
    assert one["bioguide"] == "B000944"
    assert one["bio"] == nil

    term = one["terms"] |> List.first
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
