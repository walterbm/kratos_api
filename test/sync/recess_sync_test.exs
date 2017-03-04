defmodule KratosApi.RecessSyncTest do
  use KratosApi.ModelCase
  import Ecto.Query

  alias KratosApi.{
    Repo,
    CongressionalRecess,
  }

  test "syncing creates Congressional Recess dates" do
    KratosApi.Sync.sync(:recess)

    dates = Repo.all(from d in CongressionalRecess, where: d.year == 2017)
    assert dates |> Enum.count == 13
  end

end
