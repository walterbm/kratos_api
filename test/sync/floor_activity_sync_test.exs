defmodule KratosApi.FloorSyncTest do
  use KratosApi.ModelCase
  import Ecto.Query

  alias KratosApi.{
    Repo,
    FloorActivity
  }

  test "syncing creates a record of floor activities for the House" do
    KratosApi.Sync.sync(:bill)
    KratosApi.Sync.Floor.sync(:house)

    assert Repo.all(FloorActivity) |> Enum.count == 15

    activity = Repo.one(from fa in FloorActivity, where: fa.title == "Santa Ana River Wash Plan Land Exchange Act", preload: [:bill])
    assert activity
    assert activity.md5
    assert activity.active == true
    assert activity.chamber == "house"
    assert activity.bill_gpo_id == "hr3608-114"
    assert activity.bill
    assert activity.bill.gpo_id == "hr3608-114"
  end

  test "mutiple syncing does not create duplicate records of floor activities for the House" do
    KratosApi.Sync.Floor.sync(:house)

    assert Repo.all(FloorActivity) |> Enum.count == 15

    KratosApi.Sync.Floor.sync(:house)

    assert Repo.all(FloorActivity) |> Enum.count == 15
  end

  test "syncing creates a record of floor activities for the Senate" do
    KratosApi.Sync.sync(:bill)
    KratosApi.Sync.Floor.sync(:senate)

    assert Repo.all(FloorActivity) |> Enum.count == 17
    activity = Repo.one(from fa in FloorActivity, where: fa.title == "Health care, repeal and replace ACA", preload: [:bill])
    assert activity
    assert activity.md5
    assert activity.active == true
    assert activity.chamber == "senate"
    assert activity.bill_gpo_id == "hr3608-114"
    assert activity.bill
    assert activity.bill.gpo_id == "hr3608-114"
  end

  test "mutiple syncing does not create duplicate records of floor activities for the Senate" do
    KratosApi.Sync.Floor.sync(:senate)

    assert Repo.all(FloorActivity) |> Enum.count == 17

    KratosApi.Sync.Floor.sync(:senate)

    assert Repo.all(FloorActivity) |> Enum.count == 17
  end

end
