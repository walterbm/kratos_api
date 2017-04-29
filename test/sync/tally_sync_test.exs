defmodule KratosApi.TallySyncTest do
  use KratosApi.ModelCase
  import Ecto.Query

  alias KratosApi.{
    Tally,
    Repo
  }

  test "syncing creates Tally model" do
    KratosApi.Sync.sync(:tally)

    tally = Repo.one(from t in Tally, where: t.number == 593)
    assert tally
    assert tally.question == "On Motion to Suspend the Rules and Pass: H R 6393 Intelligence Authorization Act for Fiscal Year 2017"
    assert tally.result == "Passed"
    assert tally.chamber == "House"
    assert tally.gpo_id == "hr3608-114.2016"
  end

  test "syncing creates Vote model with proper relationships" do
    KratosApi.Sync.Person.sync
    KratosApi.Sync.sync(:tally)

    tally = Repo.one(from t in Tally, where: t.number == 133, preload: [:votes])
    votes = tally.votes |> KratosApi.Repo.preload([:person])
    assert List.first(votes).value == "Yea"
    assert List.first(votes).person.official_full_name == "Roy Blunt"
  end

  test "syncing create Tally model with proper relationships" do
    KratosApi.Sync.sync(:bill)
    KratosApi.Sync.sync(:tally)

    tally = Repo.one!(from t in Tally, where: t.gpo_id == "hr3608-114.2016", preload: [:congress_number, :bill, :votes, :subjects])
    assert tally.congress_number.number == 114
    assert tally.bill.official_title == "To amend the Internal Revenue Code of 1986 to exempt amounts paid for aircraft management services from the excise taxes imposed on transportation by air."
    assert tally.bill.gpo_id == "hr3608-114"
    assert List.first(tally.subjects).name == "Aviation and airports"
  end

  test "syncing Tally can handle nominations and VP votes" do
    KratosApi.Sync.sync(:bill)
    KratosApi.Sync.sync(:tally)

    tally = Repo.one!(from t in Tally, where: t.gpo_id == "s54-115.2017", preload: [:congress_number, :bill, :nomination, :votes])
    assert tally.type == "On the Nomination"
    assert tally.result == "Nomination Confirmed"
    assert tally.congress_number.number == 115
    assert tally.bill == nil
    assert tally.nomination.title == "Elisabeth Prince DeVos, of Michigan, to be Secretary of Education"
  end

end
