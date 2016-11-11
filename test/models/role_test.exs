defmodule KratosApi.RoleTest do
  use KratosApi.ModelCase

  alias KratosApi.Role

  @valid_attrs %{current: true, description: "some content", enddate: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, govtrack_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Role.changeset(%Role{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Role.changeset(%Role{}, @invalid_attrs)
    refute changeset.valid?
  end
end
