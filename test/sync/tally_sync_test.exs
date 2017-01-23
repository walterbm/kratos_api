defmodule KratosApi.TallySyncTest do
  use KratosApi.ModelCase
  import Ecto.Query

  alias KratosApi.{
    Tally,
    Repo
  }

  test "syncing creates Tally model" do
    KratosApi.Sync.Tally.sync
    tally = Repo.one(from t in Tally, where: t.number == 593)
    assert tally
    assert tally.question == "On Motion to Suspend the Rules and Pass: H R 6393 Intelligence Authorization Act for Fiscal Year 2017"
    assert tally.result == "Passed"
    assert tally.chamber == "House"
    assert tally.gpo_id == "hr3608-114"
  end

  test "syncing creates Vote model with proper relationships" do
    KratosApi.Sync.Person.sync
    KratosApi.Sync.Tally.sync
    tally = Repo.one(from t in Tally, where: t.number == 133, preload: [:votes])
    votes = tally.votes |> KratosApi.Repo.preload([:person])
    assert List.first(votes).value == "Yea"
    assert List.first(votes).person.official_full_name == "Roy Blunt"
  end

  test "syncing create Tally model with proper relationships" do
    KratosApi.Sync.Bill.sync
    KratosApi.Sync.Tally.sync
    tally = Repo.one!(from t in Tally, where: t.gpo_id == "hr3608-114", preload: [:congress_number, :bill, :votes])
    assert tally.congress_number.number == 114
    assert tally.bill.official_title == "To amend the Internal Revenue Code of 1986 to exempt amounts paid for aircraft management services from the excise taxes imposed on transportation by air."
    assert tally.bill.gpo_id == "hr3608-114"
    assert tally.bill_official_title == tally.bill.official_title
    assert tally.bill_short_title == tally.bill.short_title
  end

end
