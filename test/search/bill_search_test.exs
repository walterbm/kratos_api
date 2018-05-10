defmodule KratosApi.BillSearchTest do
  use KratosApi.ModelCase

  alias KratosApi.{
    Repo,
    Bill,
    Search
  }

  setup do
    KratosApi.Sync.sync(:bill)
    bills = Repo.all(Bill)

    [bills: bills]
  end

  @tag :skip
  test "syncing indexes bills", %{bills: [bill | _rest]} do

    {:ok, response} = Search.simple_search("congress", ["bill"], bill.official_title)
    IO.inspect(response)
    assert response
  end

end
