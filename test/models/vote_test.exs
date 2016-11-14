defmodule KratosApi.VoteTest do
  use KratosApi.ModelCase

  alias KratosApi.Vote

  @valid_attrs %{category: "some content", category_label: "some content", chamber: "some content", created: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, govetrack_id: 42, link: "some content", margin: "120.5", missing_data: true, number: 42, percent_plus: "120.5", question: "some content", question_details: "some content", related_amendment: 42, required: "some content", result: "some content", session: "some content", source: "some content", source_label: "some content", total_minus: 42, total_other: 42, total_plus: 42, vote_type: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Vote.changeset(%Vote{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Vote.changeset(%Vote{}, @invalid_attrs)
    refute changeset.valid?
  end
end
