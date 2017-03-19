defmodule KratosApi.SubjectControllerTest do
  use KratosApi.ConnCase

  setup do
    KratosApi.Sync.sync(:bill)

    {:ok, jwt, _full_claims} =
      KratosApi.User.changeset(%KratosApi.User{}, KratosApi.Teststubs.user)
      |> KratosApi.Repo.insert!
      |> Guardian.encode_and_sign
    %{jwt: jwt}
  end


  test "GET /api/subjects", %{conn: conn, jwt: jwt} do
    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/subjects")

    response = json_response(conn, 200) |> Map.get("data")
    assert response |> List.first |> Map.get("name") == "Emergency medical services and trauma care"
    assert response |> Enum.map(&(Map.get(&1, "name"))) ==
      ["Emergency medical services and trauma care",
      "Health",
      "Health care coverage and access",
      "Hospital care",
      "Licensing and registrations",
      "Medicare",
      "Rural conditions and development",
      "Aviation and airports",
      "Sales and excise taxes",
      "Taxation",
      "Transportation safety and security"]
  end
end
