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
    response = json_response(conn, 200)
    assert response["data"] |> Enum.count == 1
    one = response["data"] |> List.first
    assert one["gpo_id"] == "hr3609-114"
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
    user = Repo.get_by(User, email: KratosApi.Teststubs.user.email)

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> put_req_header("content-type", "application/json")
      |> post("/api/me/bills", Poison.encode!(%{track: %{bill_id: bill.id}}))

    assert json_response(conn, 200)
    following = Repo.get_by(UserBill, user_id: user.id)
    assert following.bill_id == bill.id
  end

  test "DELETE /api/me/bills/:id", %{conn: conn, jwt: jwt} do
    my_bill = Repo.all(UserBill) |> List.first

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> delete("/api/me/bills/#{my_bill.bill_id}")

    assert json_response(conn, 200) == %{"ok" => true}
    assert Repo.all(UserBill) |> Enum.empty?
  end

end
