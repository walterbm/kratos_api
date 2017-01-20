defmodule KratosApi.CommitteeSyncTest do
  use KratosApi.ModelCase
  import Ecto.Query

  alias KratosApi.{
    Repo,
    Committee,
    Person
  }

  test "syncing creates Committee" do
    KratosApi.Sync.Committee.sync

    assert Repo.all(Committee) |> Enum.count == 2

    committee = Repo.one!(
      from c in Committee,
      where: c.thomas_id == "HSAG")

    assert committee
    assert committee.type == "house"
    assert committee.name == "House Committee on Agriculture"
    assert committee.url == "http://agriculture.house.gov/"
    assert committee.minority_url == "http://democrats.agriculture.house.gov/"
    assert committee.thomas_id == "HSAG"
    assert committee.house_committee_id == "AG"
    assert committee.address == "1301 LHOB; Washington, DC 20515-6001"
    assert committee.phone == "(202) 225-2171"
    assert committee.rss_url == "http://agriculture.house.gov/rss.xml"
    assert committee.minority_rss_url == "http://democrats.agriculture.house.gov/Rss.aspx?GroupID=1"
    assert committee.jurisdiction == "The House Committee on Agriculture has jurisdiction over federal agriculture policy and oversight of some federal agencies, and it can recommend funding appropriations for various governmental agencies, programs, and activities, as defined by House rules."
    assert committee.jurisdiction_source == "http://en.wikipedia.org/wiki/House_Committee_on_Agriculture"
  end

  test "syncing creates Committee Membership" do
    KratosApi.Sync.Person.sync
    KratosApi.Sync.Committee.sync
    KratosApi.Sync.Committee.Membership.sync

    committee = Repo.one!(
      from c in Committee,
      where: c.thomas_id == "HSII",
      preload: [:members])

    person = Repo.one!(
      from p in Person,
      where: p.bioguide == "B001250"
    )

    assert committee.members |> Enum.count == 1
    member = committee.members |> List.first |> Repo.preload(:person)
    assert member
    assert member.title == "Chair"
    assert member.person.bioguide == "B001250"
    assert member.person == person

    person = person |> Repo.preload(:committee_memberships)

    assert person.committee_memberships
    membership = person.committee_memberships |> List.first |> Repo.preload(:committee)
    assert membership.title == "Chair"
    assert membership.committee |> Repo.preload(:members) == committee
  end

end
