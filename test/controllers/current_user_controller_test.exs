defmodule KratosApi.CurrentUserControllerTest do
  use KratosApi.ConnCase

  alias KratosApi.{
    Repo,
    User,
    Tally,
    Bill,
    UserAction
  }

  setup do
    user = Repo.insert!(User.changeset(%User{}, %{first_name: "Test", last_name: "McTest", phone: 12404180363, password: "password", address: "700 Grand", city: "ToonTown", state: "NY", zip: 123456, district: 7}))

    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)
    %{jwt: jwt}
  end

  test "POST /api/me/actions", %{conn: conn, jwt: jwt} do
    KratosApi.Sync.Bill.sync
    bill = Repo.all(Bill) |> List.first
    KratosApi.Sync.Tally.sync
    tally = Repo.all(Tally) |> List.first


    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> put_req_header("content-type", "application/json")
      |> post("/api/me/actions", Poison.encode!(%{user_action: %{action: "call", last_bill_id: bill.id, last_tally_id: tally.id, last_bill_seen_at: "2017-01-08T18:06:54+00:00", last_tally_seen_at: "2017-01-08T18:06:54+00:00"}}))

    assert json_response(conn, 200) == %{"ok" => true}
    
    user_action = Repo.all(UserAction) |> List.first |> Repo.preload([:last_bill, :last_tally])
    assert user_action.action == "call"
    assert user_action.last_bill.id == bill.id
    assert user_action.last_tally.id == tally.id
    assert Ecto.DateTime.to_iso8601(user_action.last_bill_seen_at) == "2017-01-08T18:06:54"
    assert Ecto.DateTime.to_iso8601(user_action.last_tally_seen_at) == "2017-01-08T18:06:54"

  end

end
