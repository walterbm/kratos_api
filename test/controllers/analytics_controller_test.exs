defmodule KratosApi.AnalyticsControllerTest do
  use KratosApi.ConnCase

  alias KratosApi.Repo
  alias KratosApi.Analytics.TrackResource

  setup do
    changeset = KratosApi.User.changeset(%KratosApi.User{}, KratosApi.Teststubs.user)
    {:ok, user} = KratosApi.Repo.insert(changeset)
    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)
    %{jwt: jwt, user: user}
  end

  test "track person views", %{conn: conn, jwt: jwt, user: user} do
    assert Repo.all(TrackResource) |> Enum.count == 0

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> post("/api/analytics/track/person/4")

    response = json_response(conn, 200)

    assert response["tracked"] == true

    all = Repo.all(TrackResource)
    assert all |> Enum.count == 1

    [first | _rest] = all

    assert first.resource_type == "person"
    assert first.user_id == user.id
    assert first.resource_id == 4
  end

  test "track bill views", %{conn: conn, jwt: jwt, user: user} do
    assert Repo.all(TrackResource) |> Enum.count == 0

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> post("/api/analytics/track/bill/4")

    response = json_response(conn, 200)

    assert response["tracked"] == true

    all = Repo.all(TrackResource)
    assert all |> Enum.count == 1

    [first | _rest] = all

    assert first.resource_type == "bill"
    assert first.user_id == user.id
    assert first.resource_id == 4
  end

  test "track tally views", %{conn: conn, jwt: jwt, user: user} do
    assert Repo.all(TrackResource) |> Enum.count == 0

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> post("/api/analytics/track/tally/4")

    response = json_response(conn, 200)

    assert response["tracked"] == true

    all = Repo.all(TrackResource)
    assert all |> Enum.count == 1

    [first | _rest] = all

    assert first.resource_type == "tally"
    assert first.user_id == user.id
    assert first.resource_id == 4
  end

end
