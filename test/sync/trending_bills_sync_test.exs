defmodule KratosApi.TrendingBillSyncTest do
  use KratosApi.ModelCase
  import Ecto.Query

  alias KratosApi.{
    Repo,
    Bill,
    TrendingBill
  }

  test "syncing creates a records for trending bills" do
    KratosApi.Sync.sync(:bill)
    KratosApi.Sync.TrendingBill.sync()

    assert Repo.all(TrendingBill) |> Enum.count == 10

    bill = Repo.one(from b in Bill, where: b.gpo_id == "hr3609-114")
    trending = Repo.one(from tb in TrendingBill, where: tb.bill_id == ^bill.id, preload: [:bill])
    assert trending
    assert trending.md5
    assert trending.source == "congress_dot_gov"
    assert trending.bill.official_title == "To amend title XVIII of the Social Security Act to modify requirements for payment under the Medicare program for ambulance services furnished by critical access hospitals, and for other purposes."
  end

  test "mutiple syncing does not create duplicate records of trending bills" do
    KratosApi.Sync.TrendingBill.sync()

    assert Repo.all(TrendingBill) |> Enum.count == 10

    KratosApi.Sync.TrendingBill.sync()

    assert Repo.all(TrendingBill) |> Enum.count == 10
  end

end
