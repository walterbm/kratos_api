defmodule KratosApi.FloorSyncTest do
  use KratosApi.ModelCase

  test "syncing creates a record of floor activities for the House" do
    KratosApi.Sync.Floor.sync(:house)

  end

  test "syncing creates a record of floor activities for the Senate" do
    KratosApi.Sync.Floor.sync(:house)

  end

end
