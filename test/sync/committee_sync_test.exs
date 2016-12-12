defmodule KratosApi.CommitteeSyncTest do
  use KratosApi.ModelCase
  import Ecto.Query

  alias KratosApi.Committee

  test "syncing creates Committee models" do
    KratosApi.Sync.Committee.sync
    committee = KratosApi.Repo.one(from c in Committee, where: c.code == "SSFR", preload: [:sub_committees])
    assert committee
    assert committee.code == "SSFR"
    assert committee.name == "Senate Committee on Foreign Relations"
    assert List.first(committee.sub_committees).code == "SSFR09"
    sub_committees = KratosApi.Repo.one(from c in Committee, where: c.code == "SSFR09", preload: [:parent])
    assert sub_committees
    assert sub_committees.name == "Africa and Global Health Policy"
    assert sub_committees.parent.code == "SSFR"
    assert sub_committees.parent.name == "Senate Committee on Foreign Relations"
  end

end
