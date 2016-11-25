defmodule KratosApi.PersonRolesTest do
  use KratosApi.ModelCase

  alias KratosApi.PersonRoles

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PersonRoles.changeset(%PersonRoles{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PersonRoles.changeset(%PersonRoles{}, @invalid_attrs)
    refute changeset.valid?
  end
end
