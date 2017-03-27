defmodule KratosApi.UserBillControllerTest do
  use KratosApi.ConnCase

  alias KratosApi.{
    Repo,
    User,
    Bill,
    UserBill
  }

  setup do
    KratosApi.Sync.sync(:bill)
    bill = Repo.all(Bill) |> List.first
    user = Repo.insert!(User.changeset(%User{}, KratosApi.Teststubs.user))
    Repo.insert!(%UserBill{user_id: user.id, bill_id: bill.id})

    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)
    %{jwt: jwt}
  end

  test "GET /api/me/bills", %{conn: conn, jwt: jwt} do
    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/me/bills")

    assert json_response(conn, 200)
  end

  test "GET /api/me/bills/:id", %{conn: conn, jwt: jwt} do
    my_bill = Repo.all(UserBill) |> List.first
    real_bill = Repo.all(Bill) |> List.first
    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/me/bills/#{my_bill.bill_id}")

    bill = json_response(conn, 200)
    assert bill["id"] == real_bill.id

  end

  test "POST /api/me/bills", %{conn: conn, jwt: jwt} do
    Repo.delete_all(UserBill)
    bill = Repo.all(Bill) |> List.first

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> put_req_header("content-type", "application/json")
      |> post("/api/me/bills", Poison.encode!(%{follow: %{bill_id: bill.id}}))

      assert json_response(conn, 200)
  end

  test "DELETE /api/me/bills/:id", %{conn: conn, jwt: jwt} do
    my_bill = Repo.all(UserBill) |> List.first

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> delete("/api/me/bills/#{my_bill.id}")

    assert json_response(conn, 200) == %{"ok" => true}
    assert Repo.all(UserBill) |> Enum.empty?

  end

end
