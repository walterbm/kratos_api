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
    assert role.person.name == "Sen. Roy Blunt [R-MO]"
    assert Enum.map(role.congress_numbers, fn congress -> congress.number end) == [112,113,114]
  end

  test "syncing a duplicate Role updates that role" do
    KratosApi.Sync.Role.sync
    KratosApi.Sync.Role.sync
    role = KratosApi.Repo.one(from r in Role, preload: [:person, :congress_numbers])
    assert role
    assert role.person
    assert role.description == "Junior Senator from Missouri"
    assert role.person.name == "Sen. Roy Blunt [R-MO]"
    assert Enum.map(role.congress_numbers, fn congress -> congress.number end) == [112,113,114]
  end


end
