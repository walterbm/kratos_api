defmodule KratosApi.BillTermTest do
  use KratosApi.ModelCase

  alias KratosApi.BillTerm

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = BillTerm.changeset(%BillTerm{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = BillTerm.changeset(%BillTerm{}, @invalid_attrs)
    refute changeset.valid?
  end
end
