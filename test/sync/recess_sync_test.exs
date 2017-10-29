defmodule KratosApi.RecessSyncTest do
  use KratosApi.ModelCase
  import Ecto.Query

  alias KratosApi.{
    Repo,
    CongressionalRecess,
  }

  test "syncing creates Congressional Recess dates for the Senate" do
    KratosApi.Sync.sync(:recess)

    dates = Repo.all(from d in CongressionalRecess, where: d.year == 2017, where: d.chamber == "senate")
    assert dates |> Enum.count == 13
  end

end
