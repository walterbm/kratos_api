defmodule KratosApi.LeadershipRoleTest do
  use KratosApi.ModelCase

  alias KratosApi.LeadershipRole

  @valid_attrs %{chamber: "some content", end: %{day: 17, month: 4, year: 2010}, start: %{day: 17, month: 4, year: 2010}, title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = LeadershipRole.changeset(%LeadershipRole{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = LeadershipRole.changeset(%LeadershipRole{}, @invalid_attrs)
    refute changeset.valid?
  end
end
