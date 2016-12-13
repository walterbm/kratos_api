defmodule KratosApi.RoleSyncTest do
  use KratosApi.ModelCase
  import Ecto.Query

  alias KratosApi.Role

  test "syncing creates Role, Person, and CongressNumber models" do
    KratosApi.Sync.Role.sync
    role = KratosApi.Repo.one(from r in Role, preload: [:person, :congress_numbers])
    assert role
    assert role.person
    assert role.description == "Junior Senator from Missouri"
    assert role.govtrack_id == 268
    assert role.person.name == "Sen. Roy Blunt [R-MO]"
    assert role.person.current_state == "MO"
    assert role.person.current_party == "R"
    assert Enum.map(role.congress_numbers, fn congress -> congress.number end) == [112,113,114]
  end

  test "syncing creates reverse relationship from Person to Role" do
    KratosApi.Sync.Role.sync
    person = KratosApi.Repo.one(from person in KratosApi.Person, preload: [:roles])
    assert person
    assert List.first(person.roles).description == "Junior Senator from Missouri"
  end

  test "syncing a duplicate Role updates that role" do
    KratosApi.Sync.Role.sync
    KratosApi.Sync.Role.sync
    role = KratosApi.Repo.one(from r in Role, preload: [:person, :congress_numbers])
    assert role
    assert role.person
    assert role.description == "Junior Senator from Missouri"
    assert role.govtrack_id == 268
    assert role.person.name == "Sen. Roy Blunt [R-MO]"
    assert Enum.map(role.congress_numbers, fn congress -> congress.number end) == [112,113,114]
  end


end
