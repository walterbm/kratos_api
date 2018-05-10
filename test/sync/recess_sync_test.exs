defmodule KratosApi.RecessSyncTest do
  use KratosApi.ModelCase
  import Ecto.Query

  alias KratosApi.{
    Repo,
    CongressionalRecess,
  }

  test "syncing creates Congressional Recess dates for the Senate" do
    KratosApi.Sync.sync(:recess)

    year = Date.utc_today() |> Map.get(:year)
    dates = Repo.all(from d in CongressionalRecess, where: d.year == ^year, where: d.chamber == "senate")
    assert dates |> Enum.count == 13
  end

end
