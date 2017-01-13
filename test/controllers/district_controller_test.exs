defmodule KratosApi.DistrictControllerTest do
  use KratosApi.ConnCase

  setup do
    KratosApi.Sync.Role.sync

    changeset = KratosApi.User.changeset(%KratosApi.User{}, KratosApi.Teststubs.user)
    {:ok, user} = KratosApi.Repo.insert(changeset)
    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)
    %{jwt: jwt}
  end


  test "GET /api/districts/:state/:district", %{conn: conn, jwt: jwt} do
    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/districts/mo/1")

    one = json_response(conn, 200)["data"] |> List.first
    assert one["lastname"] == "Blunt"
    assert one["firstname"] == "Roy"
    assert one["bioguideid"] == "B000575"
    assert one["cspanid"] == 45465
    assert one["current_party"] == "R"
    assert one["current_state"] == "MO"
    assert one["image_url"] == "/225x275/B000575.jpg"
    assert one["name"] == "Sen. Roy Blunt [R-MO]"
    assert one["osid"] == "N00005195"
    assert one["pvsid"] == "418"

    one_role = one["roles"] |> List.first
    assert one_role["description"] == "Junior Senator from Missouri"
    assert one_role["current"] == true
    assert one_role["party"] == "Republican"
    assert one_role["role_type"] == "senator"
    assert one_role["role_type_label"] == "Senator"
    assert one_role["senator_class"] == "class3"
    assert one_role["senator_class_label"] == "Class 3"
    assert one_role["senator_rank"] == "junior"
    assert one_role["senator_rank_label"] == "Junior"
    assert one_role["state"] == "MO"
    assert one_role["title"] == "Sen."
    assert one_role["title_long"] == "Senator"
    assert one_role["website"] == "http://www.blunt.senate.gov"
  end
end
