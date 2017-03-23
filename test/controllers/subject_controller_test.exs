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
    assert response |> Enum.map(&(Map.get(&1, "name"))) ==
      ["Health",
      "Emergency medical services and trauma care",
      "Health care coverage and access",
      "Hospital care",
      "Licensing and registrations",
      "Medicare",
      "Rural conditions and development",
      "Taxation",
      "Aviation and airports",
      "Sales and excise taxes",
      "Transportation safety and security"]
  end
end
