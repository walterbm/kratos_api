defmodule KratosApi.CurrentUserControllerTest do
  use KratosApi.ConnCase

  alias KratosApi.{
    Repo,
    User,
    Tally,
    Bill,
    Person,
    UserAction,
    Teststubs,
  }

  setup do
    user = Repo.insert!(User.changeset(%User{}, Teststubs.user))

    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)
    %{jwt: jwt}
  end

  test "current user can update their information", %{conn: conn, jwt: jwt} do
    user = Repo.get_by(User, email: Teststubs.user.email)
    assert user.push_token == nil

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> put_req_header("content-type", "application/json")
      |> post("/api/me", Poison.encode!(%{user: %{first_name: "Kobe", last_name: "Bryant", push_token: "imacomputer"}}))

    assert json_response(conn, 201)
    reponse = json_response(conn, 201)

    assert reponse["first_name"] == "Kobe"
    assert reponse["last_name"] == "Bryant"
    assert reponse["has_push_token"] == true
    assert reponse["address"] == "1 AT&T Center Parkway"
  end

  test "POST /api/me/actions", %{conn: conn, jwt: jwt} do
    KratosApi.Sync.Person.sync
    person = Repo.all(Person) |> List.first
    KratosApi.Sync.sync(:bill)
    bill = Repo.all(Bill) |> List.first
    KratosApi.Sync.sync(:tally)
    tally = Repo.all(Tally) |> List.first


    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> put_req_header("content-type", "application/json")
      |> post("/api/me/actions", Poison.encode!(%{user_action: %{action: "call", person_id: person.id, last_bill_id: bill.id, last_tally_id: tally.id, last_bill_seen_at: "2017-01-08T18:06:54+00:00", last_tally_seen_at: "2017-01-08T18:06:54+00:00"}}))

    assert json_response(conn, 200) == %{"ok" => true}

    user_action = Repo.all(UserAction) |> List.first |> Repo.preload([:last_bill, :last_tally, :person])
    assert user_action.action == "call"
    assert user_action.last_bill.id == bill.id
    assert user_action.last_tally.id == tally.id
    assert user_action.person.id == person.id
    assert Ecto.DateTime.to_iso8601(user_action.last_bill_seen_at) == "2017-01-08T18:06:54"
    assert Ecto.DateTime.to_iso8601(user_action.last_tally_seen_at) == "2017-01-08T18:06:54"

  end

end
