defmodule KratosApi.PersonCommitteeTest do
  use KratosApi.ModelCase

  alias KratosApi.PersonCommittee

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PersonCommittee.changeset(%PersonCommittee{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PersonCommittee.changeset(%PersonCommittee{}, @invalid_attrs)
    refute changeset.valid?
  end
end
