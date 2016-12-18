defmodule KratosApi.TallyTest do
  use KratosApi.ModelCase

  alias KratosApi.Tally

  @valid_attrs %{amendment: %{}, category: "some content", chamber: "some content", date: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, gpo_id: "some content", number: 42, question: "some content", record_updated_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, requires: "some content", result: "some content", result_text: "some content", session: "some content", source_url: "some content", subject: "some content", treaty: %{}, type: "some content"}
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
