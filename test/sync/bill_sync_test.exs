defmodule KratosApi.BillSyncTest do
  use KratosApi.ModelCase
  import Ecto.Query

  alias KratosApi.Bill

  test "syncing creates Bill models" do
    KratosApi.Sync.Bill.sync
    bill = KratosApi.Repo.one(from b in Bill, where: b.gpo_id == "hr3608-114")
    assert bill
    assert bill.gpo_id == "hr3608-114"
    assert bill.active == true
    assert bill.enacted == false
    assert bill.summary_text == "(Sec. 1) This bill amends the Internal Revenue Code to exempt from the excise tax on transportation of persons and property by air amounts paid by an aircraft owner or lessee for aircraft management services related to maintenance and support of the aircraft or flights on such aircraft.\n\nAircraft management services include assisting an aircraft owner with administrative and support services; obtaining insurance; maintenance, storage and fueling of aircraft; hiring, training, and provision of pilots and crew; establishing and complying with safety standards; or other services necessary to support flights operated by an aircraft owner.\n\nIn the case of an aircraft owner that is wholly-owned by another person, amounts paid by the other person on behalf of the aircraft owner must be treated as having been paid directly by the aircraft owner."
  end

  test "syncing create Bill model with proper relationships" do
    KratosApi.Sync.Person.sync
    person = KratosApi.Repo.one!(
      from p in KratosApi.Person,
      where: p.bioguide == "B000575"
    )
    assert person
    
    KratosApi.Sync.Bill.sync
    bill = KratosApi.Repo.one(from b in Bill, where: b.gpo_id == "hr3608-114", preload: [:congress_number, :subjects, :sponsor, :cosponsors, :related_bills])
    assert bill
    assert bill.congress_number.number == 114
    assert bill.sponsor.official_full_name == "Roy Blunt"
    assert List.first(bill.subjects).name == "Aviation and airports"
    assert List.first(bill.cosponsors).official_full_name == "Roy Blunt"
    first_related_bill = List.first(bill.related_bills) |> KratosApi.Repo.preload([:bill, :related_bill])
    assert first_related_bill.bill.gpo_id == "hr3608-114"
    assert first_related_bill.related_bill.gpo_id == "hr3609-114"
  end

end
