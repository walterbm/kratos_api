defmodule KratosApi.DistrictControllerTest do
  use KratosApi.ConnCase

  setup do
    KratosApi.Sync.Role.sync

    changeset = KratosApi.User.changeset(%KratosApi.User{}, %{first_name: "Test", last_name: "McTest", phone: 12404180363, password: "password", address: "700 Grand", city: "ToonTown", state: "NY", zip: 123456, district: 7})
    {:ok, user} = KratosApi.Repo.insert(changeset)
    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)
    %{jwt: jwt}
  end


  test "GET /api/districts/:state/:district", %{conn: conn, jwt: jwt} do
    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/districts/mo/1")

    one = json_response(conn, 200)["data"] |> List.first
    assert one["description"] == "Junior Senator from Missouri"
    assert one["govtrack_id"] == 268
    assert one["person"]["lastname"] == "Blunt"
    assert one["congress_numbers"] == [112,113,114]
  end
end
