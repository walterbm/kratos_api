defmodule KratosApi.FloorSyncTest do
  use KratosApi.ModelCase
  import Ecto.Query

  alias KratosApi.{
    Repo,
    FloorActivity
  }

  test "syncing creates a record of floor activities for the House" do
    KratosApi.Sync.Floor.sync(:house)

    assert Repo.all(FloorActivity) |> Enum.count == 86

    activity = Repo.one(from fa in FloorActivity, where: fa.title == "Legislative Day Of June 20, 2017  - 7:03:58 P.M.")
    assert activity
    assert activity.chamber == "house"
    assert activity.description == "\nMr. Rutherford moved to suspend the rules and pass the bill, as amended. <a rel=\"bill\" href=\"https://www.congress.gov/bill/115th-congress/house-bill/2283\">H.R. 2283</a> — \"<b>To amend the Homeland Security Act of 2002 to improve morale within the Department of Homeland Security workforce by conferring new responsibilities to the Chief Human Capital Officer, establishing an employee engagement steering committee, requiring action plans, and authorizing an annual employee award program, and for other purposes</b>.\"\n"
    assert activity.link == "http://clerk.house.gov/floorsummary/floor.aspx?day=20170620"
    assert activity.day == Ecto.Date.cast!("2017-06-20")
  end

  test "syncing creates a record of floor activities for the Senate" do
    KratosApi.Sync.Floor.sync(:senate)

  end

end
