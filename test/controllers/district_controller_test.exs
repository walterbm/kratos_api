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

  test "find district through search", %{conn: conn, jwt: jwt} do
    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> put_req_header("content-type", "application/json")
      |> post("/api/districts", Poison.encode!(%{query: "San Fransisco"}))

    assert json_response(conn, 200) == [%{
      "state" =>  "CA",
      "district" => 12
    }]
  end


  test "get representatives for a specific state's district", %{conn: conn, jwt: jwt} do
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
  end
end
