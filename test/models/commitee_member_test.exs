defmodule KratosApi.CommiteeMemberTest do
  use KratosApi.ModelCase

  alias KratosApi.CommiteeMember

  @valid_attrs %{title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CommiteeMember.changeset(%CommiteeMember{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CommiteeMember.changeset(%CommiteeMember{}, @invalid_attrs)
    refute changeset.valid?
  end
end
