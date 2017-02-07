defmodule KratosApi.BillControllerTest do
  use KratosApi.ConnCase
  import Ecto.Query

  setup do
    KratosApi.Sync.Person.sync
    KratosApi.Sync.Committee.sync
    KratosApi.Sync.sync(:bill)
    :timer.sleep(100)

    changeset = KratosApi.User.changeset(%KratosApi.User{}, KratosApi.Teststubs.user)
    {:ok, user} = KratosApi.Repo.insert(changeset)
    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)
    %{jwt: jwt}
  end


  test "GET /api/bills/:id", %{conn: conn, jwt: jwt} do
    bill = KratosApi.Repo.one!(from b in KratosApi.Bill, where: b.gpo_id == "hr3608-114")
    conn = conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/bills/#{bill.id}")

    one = json_response(conn, 200)
    assert one["type"] == "hr"
    assert one["vetoed"] == false
    assert one["summary_text"] == "(Sec. 1) This bill amends the Internal Revenue Code to exempt from the excise tax on transportation of persons and property by air amounts paid by an aircraft owner or lessee for aircraft management services related to maintenance and support of the aircraft or flights on such aircraft.\n\nAircraft management services include assisting an aircraft owner with administrative and support services; obtaining insurance; maintenance, storage and fueling of aircraft; hiring, training, and provision of pilots and crew; establishing and complying with safety standards; or other services necessary to support flights operated by an aircraft owner.\n\nIn the case of an aircraft owner that is wholly-owned by another person, amounts paid by the other person on behalf of the aircraft owner must be treated as having been paid directly by the aircraft owner."
    assert one["subjects"] |> List.first == "Aviation and airports"
    assert one["sponsor"]["bioguide"] == "B000575"
    assert one["sponsor"]["terms"] |> List.first |> Map.get("type") == "Senate"
    assert one["gpo_id"] == "hr3608-114"
    assert one["cosponsors"] |> List.first |> Map.get("bioguide") == "B000575"
    assert one["cosponsors"] |> List.first |> Map.get("terms") |> List.first |> Map.get("state_rank") == "junior"
    assert one["congress_number"] == 114
    assert one["committees"] |> List.first |> Map.get("thomas_id") == "HSAG"
    assert one["related_bills"] |> List.first |> Map.get("reason") == "identical"
  end
end
