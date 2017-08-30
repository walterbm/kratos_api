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
    [bill_one | [bill_two | _rest]] = Repo.all(Bill)
    user = Repo.insert!(User.changeset(%User{}, KratosApi.Teststubs.user))
    Repo.insert!(%UserBill{user_id: user.id, bill_id: bill_one.id})
    Repo.insert!(%UserBill{user_id: user.id, bill_id: bill_two.id})

    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)
    %{jwt: jwt}
  end

  test "GET /api/me/bills", %{conn: conn, jwt: jwt} do
    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/me/bills")

    assert json_response(conn, 200)
    response = json_response(conn, 200)
    assert response["data"] |> Enum.count == 2
    one = response["data"] |> List.first
    assert one["gpo_id"] == "hr3609-114"
  end

  test "GET /api/me/bills only IDs", %{conn: conn, jwt: jwt} do
    [bill_one | _bill_two ] = Repo.all(Bill)

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/me/bills?onlyids=true")

    assert json_response(conn, 200)
    response = json_response(conn, 200)
    assert response["data"] |> Enum.count == 2
    one = response["data"] |> List.first
    assert one == bill_one.id
  end

  test "GET /api/me/bills filter by primary tags", %{conn: conn, jwt: jwt} do
    [bill_one | [bill_two | _rest]] = Repo.all(Bill)

    assert bill_one.top_subject_id != bill_two.top_subject_id

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/me/bills?subjects[]=#{bill_one.top_subject_id}")

    assert json_response(conn, 200)
    response = json_response(conn, 200)
    assert response["data"] |> Enum.count == 2
    one = response["data"] |> List.first
    assert one["top_subject"]["id"] == bill_one.top_subject_id
  end

  test "GET /api/me/bills filter by primary tags exclusive", %{conn: conn, jwt: jwt} do
    [bill_one | [bill_two | _rest]] = Repo.all(Bill)

    assert bill_one.top_subject_id != bill_two.top_subject_id

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/me/bills?subjects[]=#{bill_one.top_subject_id}&exclusive=true")

    assert json_response(conn, 200)
    response = json_response(conn, 200)
    assert response["data"] |> Enum.count == 1
    one = response["data"] |> List.first
    assert one["top_subject"]["id"] == bill_one.top_subject_id
  end

  test "GET /api/me/bills/:id", %{conn: conn, jwt: jwt} do
    [my_bill | _bill_two ] = Repo.all(UserBill)
    [real_bill | _bill_two ] = Repo.all(Bill)

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/me/bills/#{my_bill.bill_id}")

    bill = json_response(conn, 200)
    assert bill["id"] == real_bill.id
  end

  test "POST /api/me/bills", %{conn: conn, jwt: jwt} do
    Repo.delete_all(UserBill)
    [bill_one | _bill_two ] = Repo.all(Bill)
    user = Repo.get_by(User, email: KratosApi.Teststubs.user.email)

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> put_req_header("content-type", "application/json")
      |> post("/api/me/bills", Poison.encode!(%{track: %{bill_id: bill_one.id}}))

    assert json_response(conn, 200)
    response = json_response(conn, 200)
    assert response["data"] |> Enum.count == 1
    one = response["data"] |> List.first
    assert one == bill_one.id

    following = Repo.get_by(UserBill, user_id: user.id)
    assert following.bill_id == bill_one.id
  end

  test "POST /api/me/bills with a string-type bill_id", %{conn: conn, jwt: jwt} do
    Repo.delete_all(UserBill)
    [bill_one | _bill_two ] = Repo.all(Bill)
    user = Repo.get_by(User, email: KratosApi.Teststubs.user.email)

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> put_req_header("content-type", "application/json")
      |> post("/api/me/bills", Poison.encode!(%{track: %{bill_id: "#{bill_one.id}"}}))

    assert json_response(conn, 200)
    following = Repo.get_by(UserBill, user_id: user.id)
    assert following.bill_id == bill_one.id
  end

  test "DELETE /api/me/bills/:id", %{conn: conn, jwt: jwt} do
    [my_bill_one | [my_bill_two | _rest]] = Repo.all(UserBill)

    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> delete("/api/me/bills/#{my_bill_one.bill_id}")

    conn = recycle(conn)
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> delete("/api/me/bills/#{my_bill_two.bill_id}")

    assert json_response(conn, 200) == %{"ok" => true}
    assert Repo.all(UserBill) |> Enum.empty?
  end

end
