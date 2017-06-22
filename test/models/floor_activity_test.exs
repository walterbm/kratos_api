defmodule KratosApi.FloorActivityTest do
  use KratosApi.ModelCase

  alias KratosApi.FloorActivity

  @valid_attrs %{chamber: "some content", day: %{day: 17, month: 4, year: 2010}, description: "some content", link: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = FloorActivity.changeset(%FloorActivity{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = FloorActivity.changeset(%FloorActivity{}, @invalid_attrs)
    refute changeset.valid?
  end
end
