defmodule KratosApi.FloorActivityTest do
  use KratosApi.ModelCase

  alias KratosApi.FloorActivity

  @valid_attrs %{chamber: "some content", published_at: %{day: 23, month: 6, usec: 0, year: 2017, hour: 10, min: 43, sec: 9}, description: "some content", link: "some content", title: "some content", md5: "cabbage"}
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
