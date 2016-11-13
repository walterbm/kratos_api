defmodule KratosApi.BillTest do
  use KratosApi.ModelCase

  alias KratosApi.Bill

  @valid_attrs %{govtrack_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Bill.changeset(%Bill{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Bill.changeset(%Bill{}, @invalid_attrs)
    refute changeset.valid?
  end
end
