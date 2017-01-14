defmodule KratosApi.TermTest do
  use KratosApi.ModelCase

  alias KratosApi.Term

  @valid_attrs %{current: true, description: "some content", enddate: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, govtrack_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Term.changeset(%Term{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Term.changeset(%Term{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "add Term to database" do
    Term.changeset(%Term{}, @valid_attrs) |> KratosApi.Repo.insert
    term = KratosApi.Repo.one(Term)
    assert term
  end
end
