defmodule KratosApi.TallyTest do
  use KratosApi.ModelCase

  alias KratosApi.Tally

  @valid_attrs %{created: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, govtrack_id: 42, key: "some content", value: "some content", voter_type: "some content", voter_type_label: "some content", voteview_extra_code: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Tally.changeset(%Tally{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Tally.changeset(%Tally{}, @invalid_attrs)
    refute changeset.valid?
  end
end
