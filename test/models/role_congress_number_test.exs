defmodule KratosApi.RoleCongressNumberTest do
  use KratosApi.ModelCase

  alias KratosApi.RoleCongressNumber

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = RoleCongressNumber.changeset(%RoleCongressNumber{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = RoleCongressNumber.changeset(%RoleCongressNumber{}, @invalid_attrs)
    refute changeset.valid?
  end
end
