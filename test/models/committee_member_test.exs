defmodule KratosApi.CommitteeMemberTest do
  use KratosApi.ModelCase

  alias KratosApi.CommitteeMember

  @valid_attrs %{person_id: 1, committee_id: 2}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CommitteeMember.changeset(%CommitteeMember{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CommitteeMember.changeset(%CommitteeMember{}, @invalid_attrs)
    refute changeset.valid?
  end
end
