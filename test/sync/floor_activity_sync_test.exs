defmodule KratosApi.FloorSyncTest do
  use KratosApi.ModelCase
  import Ecto.Query

  alias KratosApi.{
    Repo,
    FloorActivity
  }

  test "syncing creates a record of floor activities for the House" do
    KratosApi.Sync.Floor.sync(:house)

    assert Repo.all(FloorActivity) |> Enum.count == 51

    activity = Repo.one(from fa in FloorActivity, where: fa.title == "Legislative Day Of June 23, 2017  - 10:43:09 A.M.")
    assert activity
    assert activity.md5
    assert activity.chamber == "house"
    assert activity.description == "\nOn agreeing to the Krishnamoorthi amendment; Agreed to by recorded vote: 380 - 32 <a rel=\"vote\" href=\"http://clerk.house.gov/cgi-bin/vote.asp?year=2017&amp;rollnumber=320\">(Roll no. 320)</a>.\n"
    assert activity.link == "http://clerk.house.gov/floorsummary/floor.aspx?day=20170623"
    assert activity.published_at == Ecto.DateTime.cast!("2017-06-23T15:17:00Z")
  end

  test "syncing creates a record of floor activities for the Senate" do
    KratosApi.Sync.Floor.sync(:senate)

  end

end
