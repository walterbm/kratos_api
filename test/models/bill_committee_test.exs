defmodule KratosApi.BillCommitteeTest do
  use KratosApi.ModelCase

  alias KratosApi.BillCommittee

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = BillCommittee.changeset(%BillCommittee{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = BillCommittee.changeset(%BillCommittee{}, @invalid_attrs)
    refute changeset.valid?
  end
end
