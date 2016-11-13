defmodule KratosApi.BillCosponsorTest do
  use KratosApi.ModelCase

  alias KratosApi.BillCosponsor

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = BillCosponsor.changeset(%BillCosponsor{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = BillCosponsor.changeset(%BillCosponsor{}, @invalid_attrs)
    refute changeset.valid?
  end
end
